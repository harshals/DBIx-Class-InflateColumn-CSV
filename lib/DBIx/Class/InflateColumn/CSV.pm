use strict;
use warnings;
package DBIx::Class::InflateColumn::CSV;
use Carp qw/croak confess/;

=head1 NAME

DBIx::Class::InflateColumn::CSV - Comma separated values inside your columns

=head1 VERSION

Version 0.001001

=cut

our $VERSION = '0.001';

=head1 SYNOPSIS

Load this component and declare columns as csv column.

    package Table;
    __PACKAGE__->load_components(qw/InflateColumn::CSV Core/);
    __PACKAGE__->table('t');
    __PACKAGE__->add_columns(
        read => {
            data_type => 'varchar',
            is_csv  => 1,
        },
        write => {
            data_type => 'varchar',
            is_csv  => 1,
        },
   );

To add a value 

	$row->add_in_csv("read","harshal"); # ,harshal,
	$row->add_in_csv("read","john"); # ,harshal,john,

To find a single element in csv list

	$row->find_in_csv("read","harshal") ; # returns true

To remove a value from csv 

	$row->remove_from_csv("read", "harshal"); # ,john,

=head1 DESCRIPTION


Just a simple hack to store comma sperated values inside a table column.
Module exports simple functions to search, add and delete values from a
comma sperated list inside a column.

Internally it stores the values in ,el1,el2,el3, format to make it searchable
via 'LIKE' .

=head1 METHODS

=head2 add_to_csv

  $row->add_to_csv( $column, $value);

Adds $value to existing comma separated list of $column. It strips of existing ','
and replaced them by __COMMA__, hence its not searchable via SQL. 


=head2 find_in_csv

  $row->find_in_csv( $column, $value);

performs simple grep operation on the values inside $column.

Returns Boolean value.

=head2 remove_from_csv

  $row->remove_from_csv( $column, $value);

simply removes $value (if matched) from the list

=head2 register_column

Chains with L<DBIx::Class::Row/register_column>, and sets up csv 
columns appropriately. 
=cut


sub register_column {
    my $self = shift;
    my ($column, $info) = @_;
    
    $self->next::method(@_);
    
    return unless defined $info->{is_csv} and $info->{is_csv};
    
    
    $self->inflate_column(
        $column => {
	inflate => sub {
                my $val = shift;

	 	croak("value must be Scalar")
			unless ref $val ne 'ARRAY';
	 	croak("value $val must be CSV")
			unless $val =~ m/,/ ;

		my @values = grep { $_} map{ my $e = $_; $e =~ s/__COMMA__/,/g ; $e }  split(",", $val);
		
                return \@values;
            },
	    deflate => sub {
		my $val = shift;
		
	 	croak("value must be Array")
			unless ref $val eq 'ARRAY';
		
		## remove any commas
		my @values = map{ my $e = $_; $e =~ s/,/__COMMA__/g ; $e} grep { $_ }  @$val;		

                return "," . join( ",", @values) . ",";
            }
        }
    );

}

sub find_in_csv {
	my ($self, $col, $el ) = @_;

	return unless $el;

	$self->throw_exception("No such column $col to inflate") unless $self->has_column($col);

	$self->throw_exception("$col not a CSV column") unless $self->column_info($col)->{is_csv} ;
	
	my @result = grep {$_ eq $el } @{ $self->get_inflated_column($col) || [] };

	return scalar(@result);
}

sub add_to_csv {
	my ($self, $col, $el ) = @_;
	
	return unless $el;

	$self->throw_exception("No such column $col to inflate") unless $self->has_column($col);

	$self->throw_exception("$col not a CSV column") unless $self->column_info($col)->{is_csv} ;
	
	my $list = $self->get_inflated_column($col);

	push @$list, $el unless $self->find_in_csv($col, $el);

	$self->set_inflated_column($col => $list );
}
sub remove_from_csv {
	my ($self, $col, $el ) = @_;
	
	return unless $el;

	$self->throw_exception("No such column $col to inflate") unless $self->has_column($col);

	$self->throw_exception("$col not a CSV column") unless $self->column_info($col)->{is_csv} ;
	
	my $list = $self->get_inflated_column($col);

	$self->set_inflated_column(
		$col => [ grep { $_ ne $el } @$list]  );
}
1;
__END__

=head1 AUTHOR

Harshal Shah (harshal.shah@gmail.com)

=head1 BUGS

shoot an email to harshal.shah@gmail.com

=head1 COPYRIGHT & LICENSE

Copyright (C) 2010 Harshal Shah

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

