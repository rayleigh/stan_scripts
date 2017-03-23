#!/usr/local/bin/perl
use strict;
use warnings;

my $unary_file = $ARGV[0];

open(UNARYFUN, "<", $unary_file) or die "Couldn't open file $unary_file";
use constant INDENT => "  ";
while(my $fun_name = <UNARYFUN>) {
  chomp $fun_name;
  open(my $vectorize_file, ">", "${fun_name}.hpp");

  write_header_guards($vectorize_file, $fun_name);
  write_include_statements($vectorize_file, $fun_name);
  write_namespace($vectorize_file, $fun_name);
  write_struct($vectorize_file, $fun_name);
  write_function($vectorize_file, $fun_name);
  write_closers($vectorize_file, $fun_name);
}
close(UNARYFUN);

sub write_header_guards {
  my ($fh, $fun_name) = @_;
  my $header_guard_file_name = "STAN_MATH_PRIM_MAT_VECTORIZE_" 
                               . uc $fun_name . "_HPP";
  print $fh "#ifndef $header_guard_file_name\n";
  print $fh "#define $header_guard_file_name\n\n";
}

sub write_include_statements {
  my ($fh, $fun_name) = @_;
  print $fh 
  "#include <stan/math/prim/mat/vectorize/apply_scalar_unary.hpp\n";
  print $fh "#include <stan/math/prim/mat/vectorize/${fun_name}.hpp\n";
  print $fh "#include <cmath>\n\n";
}

sub write_namespace {
  my ($fh, $fun_name) = @_;
  print $fh "namespace stan {\n\n";
  print $fh INDENT . "namespace math {\n\n";
}

sub write_struct {
  my ($fh, $fun_name) = @_;
  print $fh join('', INDENT, INDENT, "struct ${fun_name}_fun {\n");
  print $fh join('', INDENT, INDENT, INDENT, "template <typename T>\n");
  print $fh join('', INDENT, INDENT, INDENT, 
                 "static inline T fun(const T& x) {\n");
  print $fh join('', INDENT, INDENT, INDENT, INDENT, 
                 "using std::${fun_name};\n");
  print $fh join('', INDENT, INDENT, INDENT, INDENT, 
                 "return ${fun_name};\n");
  print $fh join('', INDENT, INDENT, INDENT, "}\n");
  print $fh join('', INDENT, INDENT, "};\n\n");
}

sub write_function {
  my ($fh, $fun_name) = @_;
  print $fh join('', INDENT, INDENT, "template <typename T>\n");
  print $fh join('', INDENT, INDENT,  
  "inline typename apply_scalar_unary<${fun_name}_fun, T>::return_t{\n");
  print $fh join('', INDENT, INDENT, 
                 "${fun_name}(const T& x) {\n");
  print $fh join('', INDENT, INDENT, INDENT, 
  "return apply_scalar_unary<${fun_name}_fun, T>::apply(x)\n");
  print $fh join('', INDENT, INDENT, "}\n\n");
}

sub write_closers {
  my ($fh, $fun_name) = @_;
  print $fh INDENT . "}\n}\n#endif";
}
