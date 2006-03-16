use 5.008006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Net::DNS::Version',
    VERSION_FROM      => 'lib/Net/DNS/Version.pm',
    PREREQ_PM         => {},

    ($] >= 5.005 ?     
      (ABSTRACT	      => 'DNS server version grabber module',
       AUTHOR         => 'Matteo Cantoni <mcantoni@cpan.org>') : ()),
);
