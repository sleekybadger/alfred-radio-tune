#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include <mruby.h>
#include <mruby/array.h>
#include <mruby/irep.h>
#include <mruby/string.h>
#include <mruby/error.h>

#include "bytecode.c"

int main(int argc, char** argv) {
  setenv("MRB_ENV", MRB_ENV, 1);

  mrb_state *mrb;
  mrb_value mrb_argv;

  mrb = mrb_open();
  mrb_argv = mrb_ary_new(mrb);

  for (int i = 1; i < argc; i++) {
    mrb_ary_push(mrb, mrb_argv, mrb_str_new_cstr(mrb, argv[i]));
  }

  mrb_define_global_const(mrb, "ARGV", mrb_argv);
  mrb_load_irep(mrb, bytecode);

  if (mrb->exc) {
    mrb_print_error(mrb);
    mrb_close(mrb);

    return -1;
  }

  mrb_close(mrb);

  return 0;
}
