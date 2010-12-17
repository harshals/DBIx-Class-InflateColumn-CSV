package TestDB::Access;

use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::CSV Core/);
__PACKAGE__->table('access');
__PACKAGE__->add_columns(
    id => {
        data_type => 'int',
		is_nullable => 0,
		is_auto_increment => 1,
    },
    read => {
        data_type => 'varchar',
		is_nullable => 1,
        is_csv  => 1,
    },
    write => {
        data_type => 'varchar',
		is_nullable => 1,
        is_csv  => 1,
    },
    
);

__PACKAGE__->set_primary_key('id');

1;
