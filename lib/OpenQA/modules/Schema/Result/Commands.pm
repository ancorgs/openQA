# Copyright (C) 2014 SUSE Linux Products GmbH
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

package Schema::Result::Commands;
use base qw/DBIx::Class::Core/;

use db_helpers;

__PACKAGE__->table('commands');
__PACKAGE__->load_components(qw/InflateColumn::DateTime Timestamps/);
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },
    command => {
        data_type => 'text',
    },
    t_processed => {
        data_type => 'timestamp',
        is_nullable => 1
    },
    worker_id => {
        data_type => 'integer',
    },
);
__PACKAGE__->add_timestamps;

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(worker => 'Schema::Result::Workers', 'worker_id');

1;
# vim: set sw=4 et:
