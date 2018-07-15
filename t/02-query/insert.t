#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use CellBIS::SQL::Abstract;

my $sql_abstract = CellBIS::SQL::Abstract->new();
my $insert = '';

$insert = $sql_abstract->insert('table_test', ['col1', 'col2', 'col3'], ['val1', 'val2', 'NOW()']);
ok($insert eq 'INSERT INTO table_test(col1, col2, col3) VALUES(?, ?, NOW())', "SQL Query : \n$insert");

$insert = $sql_abstract->insert('table_test', ['col1', 'col2', 'col3'], ['val1', 'val2', 'val3'], 'no-pre-st');
ok($insert eq 'INSERT INTO table_test(col1, col2, col3) VALUES(val1, val2, val3)', "SQL Query [$insert] is true");

done_testing();

