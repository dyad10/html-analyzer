#!/usr/bin/perl
require HTML::TokeParser;
require Data::Dumper;

use strict;

my $dirname = "files/wired";

my @files;

opendir(DIR, $dirname) or die "cant opendir $dirname: $!";
while (defined(my $file = readdir(DIR))) {
  if($file ne '..' && $file ne '.') {
    print $dirname . '/' . $file; print "\n";
    push(@files, $dirname . "/" . $file);
  }
}
closedir(DIR);

foreach my $file (@files) {
  print $file . "\n";
  foreach my $comparison(@files) {
    if($file ne $comparison) {
      print '  ' . $comparison . "\n";
      my $p = HTML::TokeParser->new($file) || die "Cannot open $!";
      $p->empty_element_tags(1); #configure its behavior
      my $s1 = '';
      while (my $token = $p->get_token) {
        $s1 .= $token->[0];
      }

      $p = HTML::TokeParser->new($comparison) || die "Cannot open $!";
      $p->empty_element_tags(1);
      my $s2 = '';
      while (my $token = $p->get_token) {
        $s2 .= $token->[0];
      }
      print $s1 . "\n" . $s2 . "\n\n";
  #    print "The Levenshtein distance is: ";
  #    print levenshtein($s1, $s2) . "\n"; 
    
    }
  }
}

#my $p = HTML::TokeParser->new("files/ashfurrow.com/index3.html") 
#  || die "Cannot open $!";
#$p->empty_element_tags(1); # configure its behaviour

#my $s1 = '';
#while (my $token = $p->get_token) {
#  print Data::Dumper->Dump($token);
#  print	"\n\n";
#  $s1 .= $token->[0];
#} 

#$s1 = substr($s1, 0, int length($s1) / 2) . "\n*****************";

#print $s1;
#print "\n\n";
#$p = HTML::TokeParser->new("files/ashfurrow.com/index.html")
#  || die "Cannot open $!";
#$p->empty_element_tags(1);

#my $s2 = '';
#while (my $token = $p->get_token) {
#  $s2 .= $token->[0];
#}
#$s2 = substr($s2, 0, int length($s2) / 2);

#print $s2;

#print "The Levenshtein distance is: ";
#print levenshtein($s1, $s2) . "\n";
#print `/home/achen/workspace/html-analyzer/levenshtein_distance.m '$s1' '$s2'`;


# Return the Levenshtein distance (also called Edit distance) 
# between two strings
#
# The Levenshtein distance (LD) is a measure of similarity between two
# strings, denoted here by s1 and s2. The distance is the number of
# deletions, insertions or substitutions required to transform s1 into
# s2. The greater the distance, the more different the strings are.
#
# The algorithm employs a proximity matrix, which denotes the distances
# between substrings of the two given strings. Read the embedded comments
# for more info. If you want a deep understanding of the algorithm, print
# the matrix for some test strings and study it
#
# The beauty of this system is that nothing is magical - the distance
# is intuitively understandable by humans
#
# The distance is named after the Russian scientist Vladimir
# Levenshtein, who devised the algorithm in 1965
#
sub levenshtein
{
    # $s1 and $s2 are the two strings
    # $len1 and $len2 are their respective lengths
    #
    my ($s1, $s2) = @_;
    my ($len1, $len2) = (length $s1, length $s2);

    # If one of the strings is empty, the distance is the length
    # of the other string
    #
    return $len2 if ($len1 == 0);
    return $len1 if ($len2 == 0);

    my %mat;

    # Init the distance matrix
    #
    # The first row to 0..$len1
    # The first column to 0..$len2
    # The rest to 0
    #
    # The first row and column are initialized so to denote distance
    # from the empty string
    #
    for (my $i = 0; $i <= $len1; ++$i)
    {
        for (my $j = 0; $j <= $len2; ++$j)
        {
            $mat{$i}{$j} = 0;
            $mat{0}{$j} = $j;
        }

        $mat{$i}{0} = $i;
    }

    # Some char-by-char processing is ahead, so prepare
    # array of chars from the strings
    #
    my @ar1 = split(//, $s1);
    my @ar2 = split(//, $s2);

    for (my $i = 1; $i <= $len1; ++$i)
    {
        for (my $j = 1; $j <= $len2; ++$j)
        {
            # Set the cost to 1 iff the ith char of $s1
            # equals the jth of $s2
            # 
            # Denotes a substitution cost. When the char are equal
            # there is no need to substitute, so the cost is 0
            #
            my $cost = ($ar1[$i-1] eq $ar2[$j-1]) ? 0 : 1;

            # Cell $mat{$i}{$j} equals the minimum of:
            #
            # - The cell immediately above plus 1
            # - The cell immediately to the left plus 1
            # - The cell diagonally above and to the left plus the cost
            #
            # We can either insert a new char, delete a char or
            # substitute an existing char (with an associated cost)
            #
            $mat{$i}{$j} = min([$mat{$i-1}{$j} + 1,
                                $mat{$i}{$j-1} + 1,
                                $mat{$i-1}{$j-1} + $cost]);
        }
    }

    # Finally, the Levenshtein distance equals the rightmost bottom cell
    # of the matrix
    #
    # Note that $mat{$x}{$y} denotes the distance between the substrings
    # 1..$x and 1..$y
    #
    return $mat{$len1}{$len2};
}


# minimal element of a list
#
sub min
{
    my @list = @{$_[0]};
    my $min = $list[0];

    foreach my $i (@list)
    {
        $min = $i if ($i < $min);
    }

    return $min;
}

#sub dice_coefficient(){
#     my ($str1, $str2) = @_;
# 
#     return 0 if (! length $str1 || ! length $str2 );
# 
#     #### bigrams using REGEX.
#     ##my @bigrams_str1 = $str1 =~ m/ (?= (..) ) /xmsg;
#     ##my @bigrams_str2 = $str2 =~ m/ (?= (..) ) /xmsg;
# 
#     my $len1 = ( length($str1) -  1 );
#     for (my $i=0; $i<$len1; $i++){
#         push @bigrams_str1, substr($str1, $i, 2);
#     }
# 
#     my $len2 = ( length($str2) -  1 );
#     for (my $i=0; $i<$len2; $i++){
#         push @bigrams_str1, substr($str2, $i, 2);
#     }
# 
#     my $intersect = 0;
#     for (my $i=0; $i<=$#bigrams_str1; $i++){
#          if ( grep /^$bigrams_str1[$i]$/, @bigrams_str2){
#               $intersect++;
#          }
#     }
# 
#     my $combinedLength = ($#bigram_str1+1 + $#bigrams_str2+1);
#     my $dice = ($intersect * 2 / $combinedLength);
# 
##     return $dice;
#}
##
