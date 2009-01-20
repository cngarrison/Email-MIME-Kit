package Email::MIME::Kit::Assembler::Alts;
use Moose;

with 'Email::MIME::Kit::Role::Assembler::Simple';

use Email::MIME::Creator;

sub assemble {
  my ($self, $stash) = @_;

  my %attr = %{ $self->manifest->{attributes} || {} };
  $attr{content_type} = $attr{content_type} || 'multipart/alternative';

  if ($attr{content_type} !~ qr{\Amultipart/alternative\b}) {
    confess "illegal content_type for mail with alts: $attr{content_type}";
  }

  my $email = Email::MIME->create(
    attributes => \%attr,
    header     => $self->_prep_header($self->manifest->{header}, $stash),
    parts      => [ map { $_->assemble($stash) } $self->_alternatives ],
  );

  my $container = $self->_contain_attachments($email, $stash);
}

no Moose;
1;
