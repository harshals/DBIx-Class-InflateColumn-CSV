#
#===============================================================================
#
#         FILE:  02-pod.t
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Harshal Shah (Hs), <harshal.shah@gmail.com>
#      COMPANY:  MK Software
#      VERSION:  1.0
#      CREATED:  12/17/2010 13:47:04 IST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Test::More ;#tests => 1;                      # last test to print



# Ensure a recent version of Test::Pod
my $min_tp = 1.22;
eval "use Test::Pod $min_tp";
plan skip_all => "Test::Pod $min_tp required for testing POD" if $@;

all_pod_files_ok();



