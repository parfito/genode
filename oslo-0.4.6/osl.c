/*
 * \brief   OSLO - Open Secure Loader
 * \date    2006-03-28
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
#include "sha.h"
#include "elf.h"
#include "tpm.h"
#include "mp.h"
#include "osl.h"

static const char *version_string = "OSLO " VERSION "\n";
const char * message_label = "OSLO:   ";

/**
 * Function to output a hash.
 */
static void
show_hash(char *s, unsigned char *hash)
{
  out_string(message_label);
  out_string(s);
  for (unsigned i=0; i<20; i++)
    out_hex(hash[i], 7);
  out_char('\n');
}


/**
 *  Hash all multiboot modules.
 */
static
int
mbi_calc_hash(struct mbi *mbi, struct Context *ctx)
{
  unsigned res;

  CHECK3(-11, ~mbi->flags & MBI_FLAG_MODS, "module flag missing");
  CHECK3(-12, !mbi->mods_count, "no module to hash");
  out_description("Hashing modules count:", mbi->mods_count);

  struct module *m  = (struct module *) (mbi->mods_addr);
  for (unsigned i=0; i < mbi->mods_count; i++, m++)
    {
      sha1_init(ctx);
      CHECK3(-13, m->mod_end < m->mod_start, "mod_end less than start");
      sha1(ctx, (unsigned char*) m->mod_start, m->mod_end - m->mod_start);
      sha1_finish(ctx);
      CHECK4(-14, (res = TPM_Extend(ctx->buffer, 19, ctx->hash)), "TPM extend failed", res);
    }
  return 0;
}


/**
 * Prepare the TPM for skinit.
 * Returns a TIS_INIT_* value.
 */
static
int
prepare_tpm(unsigned char *buffer)
{
  int tpm, res;

  CHECK4(-60, 0 >= (tpm = tis_init(TIS_BASE)), "tis init failed", tpm);
  CHECK3(-61, !tis_access(TIS_LOCALITY_0, 0), "could not gain TIS ownership");
  if ((res=TPM_Startup_Clear(buffer)) && res!=0x26)
    out_description("TPM_Startup() failed", res);

  CHECK3(-62, tis_deactivate_all(), "tis_deactivate failed");
  return tpm;
}


/**
 * This function runs before skinit and has to enable SVM in the processor
 * and disable all localities.
 */
int
__main(struct mbi *mbi, unsigned flags)
{

  unsigned char buffer[TCG_BUFFER_SIZE];

#ifndef NDEBUG
  serial_init();
#endif
  out_string(version_string);
  ERROR(10, !mbi || flags != MBI_MAGIC, "not loaded via multiboot");

  // set bootloader name
  mbi->flags |= MBI_FLAG_BOOT_LOADER_NAME;
  mbi->boot_loader_name = (unsigned) version_string;

  int revision = 0;
  if (0 >= prepare_tpm(buffer) || (0 > (revision = check_cpuid())))
    {
      if (0 > revision)
	out_info("No SVM platform");
      else
	out_info("Could not prepare the TPM");

      ERROR(11, start_module(mbi), "start module failed");
    }

  out_description("SVM revision:", revision);
  ERROR(12, enable_svm(), "could not enable SVM");

  /**
   * All APs have to be in the INIT state before skinit can be
   * executed.
   */
  ERROR(13, stop_processors(), "sending an INIT IPI to other processors failed");

  wait(1000);
  out_info("call skinit");
  do_skinit();
}


/**
 * This code is executed after skinit.
 */
int
oslo(struct mbi *mbi)
{
  struct Context ctx;

  ERROR(20, !mbi, "no mbi in oslo()");

  if (tis_init(TIS_BASE))
    {
      ERROR(21, !tis_access(TIS_LOCALITY_2, 0), "could not gain TIS ownership");
      ERROR(22, mbi_calc_hash(mbi, &ctx),  "calc hash failed");
      show_hash("PCR[19]: ",ctx.hash);

#ifndef NDEBUG
      int res;
      dump_pcrs(ctx.buffer);

      CHECK4(24,(res = TPM_PcrRead(ctx.buffer, 17, ctx.hash)), "TPM_PcrRead failed", res);
      show_hash("PCR[17]: ",ctx.hash);
#endif
      ERROR(25, tis_deactivate_all(), "tis_deactivate failed");
  }
  ERROR(27, start_module(mbi), "start module failed");
  return 28;
}
