#
#===============================================================================
#
#         FILE:  01-csv.t
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Harshal Shah (Hs), <harshal.shah@gmail.com>
#      COMPANY:  MK Software
#      VERSION:  1.0
#      CREATED:  12/17/2010 12:05:03 IST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Test::More ;                      # last test to print

use Scalar::Util 'blessed';

BEGIN {
    use lib 't/lib';
    use TestDB;

    eval 'require DBD::SQLite';
    if ($@) {
	plan skip_all => 'DBD::SQLite not installed';
    } else {
	plan tests => 10;
    }
};

my $schema = TestDB->init_schema;

isa_ok($schema, "DBIx::Class::Schema", "Schema object loaded correctly");
my $rs = $schema->resultset('Access');

my $row = $rs->new({});

$row = $row->insert();

is($row->id, 1,"First row created");

ok($row->add_to_csv("read", "harshal"), "Add to csv");

is($row->get_column("read"), ',harshal,', "Serialized correctly");

is($row->find_in_csv("read", "john"), 0, "Cannot find John");

is($row->find_in_csv("read", "harshal"), 1, "Found Harshal");

ok($row->add_to_csv("read", "john,"), "Add john with comma");

is($row->get_column("read"), ',harshal,john__COMMA__,', "Serialized correctly");

ok($row->remove_from_csv("read", "john,"), "removed user with comma");

is($row->get_column("read"), ',harshal,', "Serialized correctly..again");

