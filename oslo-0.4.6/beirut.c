/*
 * \brief   Beirut - hashes command lines
 * \date    2006-06-07
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
#include "tpm.h"
#include "elf.h"

const char *message_label = "BEIRUT: ";


/**
 * Hash the command line including the zero byte into one hash and
 * extend PCR 19.
 */
static
int
mbi_hash_cmd_line(struct mbi *mbi, struct Context *ctx)
{
  unsigned res;

  ERROR(-11, ~mbi->flags & MBI_FLAG_MODS, "module flag missing");
  ERROR(-12, !mbi->mods_count, "no module to hash the cmdline");
  out_description("number of modules:", mbi->mods_count);

  sha1_init(ctx);

  struct module *m  = (struct module *) (mbi->mods_addr);
  for (unsigned i=0; i < mbi->mods_count; i++, m++)
    sha1(ctx, (unsigned char*) m->string, strlen((char*) m->string) + 1);

  sha1_finish(ctx);
  CHECK4(-13, (res = TPM_Extend(ctx->buffer, 19, ctx->hash)), "TPM extend failed", res);
  return 0;
}


/**
 * Hash the command line of all following mbi modules and start the
 * next one.
 */
int
__main(struct mbi *mbi, unsigned flags)
{
  struct Context ctx;

#ifndef NDEBUG
  serial_init();
#endif
  out_info(VERSION " hashes command lines");
  ERROR(10, !mbi || flags != MBI_MAGIC, "Not loaded via multiboot");

  if (tis_init(TIS_BASE) && tis_access(TIS_LOCALITY_2, 0))
    {
      if (!mbi_hash_cmd_line(mbi, &ctx))
	ERROR(12, tis_deactivate_all(), "tis_deactivate failed");
    }

  out_info("hashing done");
  ERROR(13, start_module(mbi), "start module failed");
  return 14;
}
