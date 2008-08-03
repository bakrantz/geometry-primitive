package Geometry::Primitive::Line;
use Moose;

extends 'Geometry::Primitive';

with qw(Geometry::Primitive::Shape MooseX::Clone);

use overload ('""' => 'to_string');

has 'start' => (
    is => 'rw',
    isa => 'Geometry::Primitive::Point',
    required => 1
);

has 'end' => (
    is => 'rw',
    isa => 'Geometry::Primitive::Point',
    required => 1
);

sub contains_point {
    my ($self, $x, $y) = @_;

    my $point;
    if(!ref($x) && defined($y)) {
        # This allows the user to pass in $x and $y as scalars, which
        # easier sometimes.
        $point = Geometry::Primitive::Point->new(x => $x, y => $y);
    } else {
        $point = $x;
    }

    my $expy = ($self->slope * $point->x) + $self->y_intercept;
    return $expy == $point->y;
}

sub grow { }

sub is_parallel {
    my ($self, $line) = @_;

    return $line->slope == $self->slope;
}

sub is_perpendicular {
    my ($self, $line) = @_;

    my $slope = $self->slope;

    # Deal with horizontal and vertical lines
    if(!defined($slope)) {
        return $line->slope == 0;
    }
    if($slope == 0) {
        return !defined($line->slope);
    }

    return $line->slope == (-1 / $self->slope);
}

sub length {
    my ($self) = @_;

    return sqrt(($self->end->x - $self->start->x) ** 2
        + ($self->end->y - $self->start->y) ** 2);
}

sub point_end {
    my ($self) = @_; return $self->end;
}

sub point_start {
    my ($self) = @_; return $self->start;
}

sub slope {
    my ($self) = @_;

    my $end = $self->end;
    my $start = $self->start;
    my $x = $end->x - $start->x;
    my $y = $end->y - $start->y;

    if($x == 0) {
        return undef;
    }

    return $y / $x;
}

sub to_string {
    my ($self) = @_;

    return $self->start->to_string." - ".$self->end->to_string;
}

sub y_intercept {
    my ($self) = @_;

    return $self->start->y - ($self->slope * $self->start->x);
}

__PACKAGE__->meta->make_immutable;

no Moose;
1;

__END__

=head1 NAME

Geometry::Primitive::Line

=head1 DESCRIPTION

Geometry::Primitive::Line represents a straight curve defined by two points.

=head1 SYNOPSIS

  use Geometry::Primitive::Line;

  my $line = Geometry::Primitive::Line->new();
  $line->start($point1);
  $line->end($point2);

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Geometry::Primitive::Line

=back

=head2 Instance Methods

=over 4

=item I<contains_point>

Returns true if the supplied point is 'on' the line.  Accepts either a point
object or an x y pair.

=item I<end>

Set/Get the end point of the line.

=item I<grow>

Does nothing, as I'm not show how.  Patches or hints welcome.

=item I<is_parallel ($other_line)>

Returns true if the supplied line is parallel to this one.

=item I<is_perpendicular ($other_line)>

Returns true if the supplied line is perpendicular to this one.

=item I<length>

Get the length of the line.

=item I<point_end>

Get the end point.  Provided for Shape role.

=item I<point_start>

Get the start point.  Provided for Shape role.

=item I<slope>

Get the slope of the line.

=item I<start>

Set/Get the start point of the line.

=item I<to_string>

Guess!

=item I<y_intercept>

Returns the Y intercept of this line.

=back

=head1 AUTHOR

Cory Watson <gphat@cpan.org>

Infinity Interactive, L<http://www.iinteractive.com>

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

You can redistribute and/or modify this code under the same terms as Perl
itself.