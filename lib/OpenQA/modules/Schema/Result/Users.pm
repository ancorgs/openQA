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

package Schema::Result::Users;
use base qw/DBIx::Class::Core/;

use db_helpers;

__PACKAGE__->table('users');
__PACKAGE__->load_components(qw/InflateColumn::DateTime Timestamps/);
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },
    openid => {
        data_type => 'text',
    },
    email => {
        data_type => 'text',
        is_nullable => 1,
    },
    fullname => {
        data_type => 'text',
        is_nullable => 1,
    },
    nickname => {
        data_type => 'text',
        is_nullable => 1,
    },
    is_operator => {
        data_type => 'integer',
        is_boolean => 1,
        false_id => ['0', '-1'],
        default_value => '0',
    },
    is_admin => {
        data_type => 'integer',
        is_boolean => 1,
        false_id => ['0', '-1'],
        default_value => '0',
    },
);
__PACKAGE__->add_timestamps;
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint([qw/openid/]);
__PACKAGE__->has_many(api_keys => 'Schema::Result::ApiKeys', 'user_id');

sub name{
    my $self = shift;

    if (!$self->{_name}) {
        $self->{_name} = $self->nickname;
        if (!$self->{_name}) { # old hack for opensuse openid to nick mapping
            my $id = $self->openid;
            my ($path, $user) = split(/\/([^\/]+)$/, $id);
            $self->{_name} = $user;
        }
    }
    return $self->{_name};
}

sub create_user{
    my ($self, $id, $db, %attrs) = @_;

    my $user = $db->resultset("Users")->update_or_new(
        {openid => $id, %attrs} # FIXME, need to remove the constraint_name above! , { key => 'users_openid' }
    );
    if (!$user->in_storage) {
        if(not $db->resultset("Users")->find({ is_admin => 1 }, { rows => 1 })) {
            $user->is_admin(1);
            $user->is_operator(1);
        }
        $user->insert;
    }
    return $user;
}

1;
# vim: set sw=4 et:
