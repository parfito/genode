/*
 * \brief   Pamplona - fixup code for unchanged operating systems
 * \date    2006-10-20
 * \author  Bernhard Kauer <kauer@tudos.org>
 */
/*
 * Copyright (C) 2006,2007,2010  Bernhard Kauer <kauer@tudos.org>
 * Technische Universitaet Dresden, Operating Systems Research Group
 *
 * This file is part of the OSLO package, which is distributed under
 * the  terms  of the  GNU General Public Licence 2.  Please see the
 * COPYING file for details.
 */

#include "version.h"
#include "util.h"
#include "mbi.h"
#include "elf.h"
#include "mp.h"
#include "dev.h"
#include "pamplona.h"

const char *message_label = "PAMPLONA: ";
const unsigned REALMODE_CODE = 0x20000;
const char *CPU_NAME =  "AMD CPU booted by OSLO/PAMPLONA";


/**
 * Fix some issues that unmodified OS's could start after oslo.
 * This should only be called if check_cpuid() succeded.
 */
int
pamplona_fixup()
{
  unsigned i;

  out_info("patch CPU name tag");
  CHECK3(-10, strlen(CPU_NAME)>=48,"cpu name to long");
  for (i=0; i<6; i++)
    wrmsr(0xc0010030+i, * (unsigned long long*) (CPU_NAME+i*8));

  out_info("halt APs in init state");
  int revision;

  /**
   * Start the stopped APs and execute some fixup code.
   */
  memcpy((char *) REALMODE_CODE, &smp_init_start, &smp_init_end - &smp_init_start);
  CHECK3(-2, start_processors(REALMODE_CODE), "sending an STARTUP IPI to other processors failed");


  CHECK3(12, (revision = enable_svm()), "could not enable SVM");
  out_description("SVM revision:", revision);

  out_info("enable global interrupt flag");
  asm volatile("stgi");
  return 0;
}


int
__main(struct mbi *mbi, unsigned flags)
{
#ifndef NDEBUG
  serial_init();
#endif

  out_info(VERSION " executes fixup code");
  ERROR(10, !mbi || flags != MBI_MAGIC, "not loaded via multiboot");

  ERROR(12, pci_iterate_devices(), "could not iterate over the devices");

  if (0 < check_cpuid())
    {

      CHECK3(11, pamplona_fixup(), "fixup failed");
      out_info("fixup done");

      if (disable_dev_protection())
	out_info("DEV disable failed");
    }

#if 0
  out_info("MMAP");
  out_description("addr", mbi->mmap_addr);
  out_description("len",  mbi->mmap_length);

  unsigned i;
  for ( i =  mbi->mmap_addr; i < mbi->mmap_addr + mbi->mmap_length; i += ((unsigned *)i)[0])
    {
      out_description("size",((unsigned *)i)[0]);
      out_description("addr low",((unsigned *)i)[1]);
      out_description("addr high",((unsigned *)i)[2]);
      out_description("length low",((unsigned *)i)[3]);
      out_description("length high",((unsigned *)i)[4]);
      out_description("type",((unsigned *)i)[5]);
    }

#endif
  out_info("done");
  //wait(1000);
  ERROR(13, start_module(mbi), "start module failed");
  return 14;
}
