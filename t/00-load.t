#
#===============================================================================
#
#         FILE:  00-load.t
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Harshal Shah (Hs), <harshal.shah@gmail.com>
#      COMPANY:  MK Software
#      VERSION:  1.0
#      CREATED:  12/17/2010 11:31:50 IST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Test::More tests => 1;                      # last test to print

BEGIN {
	use_ok( 'DBIx::Class::InflateColumn::CSV' );
}

diag( "Testing DBIx::Class::InflateColumn::CSV $DBIx::Class::InflateColumn::CSV::VERSION, Perl $], $^X" );


