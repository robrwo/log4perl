###########################################
# Test Suite for Log::Log4perl::Config
# Mike Schilli, 2002 (m@perlmeister.com)
###########################################

#########################
# change 'tests => 1' to 'tests => last_test_to_print';
#########################
use Test;
BEGIN { plan tests => 3 };

use Log::Log4perl;
use Log::Dispatch::Buffer;

my $EG_DIR = "eg";
$EG_DIR = "../eg" unless -d $EG_DIR;

my $date_regex = qr(\d{4}/\d\d/\d\d \d\d:\d\d:\d\d);

ok(1); # If we made it this far, we're ok.

######################################################################
# Test a 'foo.bar.baz' logger which inherits level from foo.bar
# and calls both "foo.bar" and "root" appenders with their respective
# formats
# on a configuration file defining a file appender
######################################################################
Log::Log4perl->init("$EG_DIR/log4j-manual-2.conf");

my $logger = Log::Log4perl->get_logger("foo.bar.baz");
$logger->debug("Gurgel");

ok($Log::Dispatch::Buffer::POPULATION[0]->buffer(),
   "m#$date_regex \\[N/A\\] DEBUG foo.bar.baz - Gurgel#");
#print "BUFFER= '", $Log::Dispatch::Buffer::POPULATION[0]->buffer(), "'\n";

######################################################################
# Test the root logger via inheritance (discovered by Kevin Goess)
######################################################################
Log::Log4perl->reset();

Log::Log4perl->init("$EG_DIR/log4j-manual-2.conf");

$logger = Log::Log4perl->get_logger("foo");
$logger->debug("Gurgel");

   # POPULATION[1] because it created another buffer behind our back
ok($Log::Dispatch::Buffer::POPULATION[1]->buffer(),
   "m#$date_regex \\[N/A\\] DEBUG foo - Gurgel#");
#print "BUFFER= '", $Log::Dispatch::Buffer::POPULATION[1]->buffer(), "'\n";
