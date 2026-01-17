@ARGV=("01.txt");
my ($c,$s) = (0,50);
while (<>) {
    /^(.)(\d+)/ or next;
    my $n = ($1 eq "R" ? $2 : -$2);
    $s = ($s + $n) % 100;
    $c++ if $s == 0;
}
print("$c\n")
