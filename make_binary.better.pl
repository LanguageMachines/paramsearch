#!/usr/bin/perl -w

#16 juni 2004
#binaire features!!
#eerdere versies beschouwden een binair feature gewoon 
#als een symbolisch feature met twee waarden, 
#en maakt er twee binaire features voor.

#deze versie herkent features met twee values 
#en codeert alleen de meest fr value.
#als de values 0 en 1 zijn, codeert hij alleen de 1.



#15 juni 2004
#bij snow was hij nog steeds niet nummeriek!
#ook even aangepast dus.
#er zat ook nog een bugje in snow-deel
#waardoor codering bij de testdata niet geheel goed ging!


#17 maart 2004
#
#de sortering  van het lexicon was niet nummeriek. 
#in principe maakt het eigenlijk niets uit,
#maar het staat netter!
#
#4 feb 2004
#
# This script translates timbl-format to 
# the binary format of SVMs, Maxent or Snow.
# SVM en Maxent have the same inputformat.

# Command: perl make_binary.simpel.pl [svm | snow]  trainfile ( testfile ) (-v)
# 
# NB: testset altijd tegelijk met de trainfile door dit script halen!!
# testset moet gecodeerd worden aan hand van lexicon van de trainset!!  
#
# Output :     
# -trainfile.bin (testfile.bin) 

# Met de -v optie worden er
# echter drie files gemaakt.
# -trainfile.cod (het tussenformatfile)  
# -trainfile.bin (het binaire file)   
# -trainfile.key (lexicon )
# Het binaire file is niet meer leesbaar  
# en kan zonder een lexiconlijst niet 
# meer gecheckt worden op fouten.
# Samen met .cod en .key kun je 
# de boel weer terugcoderen.
#
# NB: Als je SVMs gebruikt, 
# vergeet dan niet om de *bin files 
# ook op KLASSEN te binariseren!!
#
# Methode:
# Input is een timbl-instantie-file(gescheiden met spaties of kommas).
# Daarvan wordt iedere kolom genummerd
# en weggeschreven zodat ieder woord als betekenis woord+positie heeft.
# Hier maak je een lexicon-keylijst van. 
# lexicon gebruik je om de strings om te zetten 
# in een binaire representatie.
# (Alle features worden beschouwd als symbolisch.)
#
##################################################




#vlaggetje dat aangaat als er ook een testfile wordt meegegeven.
#testwoorden die niet in trainfile-lexicon zitten,
# worden gehercodeerd als [positie+unknown].
$test=0;
$verbosity = 0;

if($#ARGV < 1)
{
    print STDERR "Command: perl make_binary.better.pl [svm | snow |maxent]  trainfile ( testfile)\n maxent format == svm format. Optional: -v for more outputfiles\n";
    exit(0);
}
$algo =$ARGV[0];
$file = $ARGV[1];



if($#ARGV >1)
{
for $A (2 .. $#ARGV)
{
    if($ARGV[$A] eq "-v"  )
    {
	$verbosity =1;
    }
    
    
    if($ARGV[$A] ne "-v" &&
       $ARGV[$A] =~ /.*\w+.*/ )
    {
	$test =1;
	$testfile = $ARGV[$A];
	print STDERR "testfile: $testfile\n";
    }

}
}


#check of data met kommas of spaties is gescheiden
$scheider = &check_scheiding( $file);



if($algo eq "svm" ||$algo eq "maxent" )
{

    #maak eerst een array die bijhoudt 
    #of een feature wel of niet binair is.

#nbrwords zegt gewoon hoeveel woorden er per regel staan.
#dus incl klasse! en hij telt vanaf 1 en de array loopt vanaf nul
    for $c (0 .. $nbrWords-2)
    {

	$field = $c+1;
	$tmp = `cut -d'$cut_scheider' -f$field  < $file |sort |uniq -c|sort -rn`;
	chomp($tmp);
	@ef_str = split /\n/,$tmp;
	$aantal_fvalues = $#ef_str + 1;

	@tmp = split /\s+/,$ef_str[0];
	$mfr_value = $tmp[2];

	#stel nu dat als 0 en 1 gecodeerd en 0 komt vaker voor
	#dan hetscript de boel nu omdraaien.dus checken:
	if( $mfr_value eq "0" && $aantal_fvalues eq "2")
	{
	    @tmp = split /\s+/,$ef_str[1];
	    if($tmp[2] eq "1")
	    {
		$mfr_value = $tmp[2];
	    }    
	}
	
	if($aantal_fvalues eq "2")
	{
	    $bin_houder[$c] = $mfr_value;

	}else{
	    $bin_houder[$c] = "-0-";
	}	
    }



    
    &herschrijf_file($file);
    #de functie herschrijf_file()
    #maakt genummerde file met woord+positie.
    
    #maak key van deze outfile
    system("cut -d' ' -f2- < $outfile | tr -s ' ' '\\n' |sort|uniq   |sort -n |awk '{printf(\"\%d \%s\\n\",NR,\$0);}' > $file.$algo.key");
    
    #lees key in
    open(LEX,"$file.$algo.key") || die " kan $file.$algo.key niet openen";
    while(<LEX>)
    {
	$line =$_;
	chomp($line);
	@array = split /\s+/, $line;
	$lexhash{$array[$#array]} = $array[0];
	$lexgrootte = $array[0];
    }
    close(LEX);
    
    #zet met key de outfile om in een binaire file
    &maak_binair($outfile);
    
    #als er een testfile is meegeven
    if($test)
    {
	&herschrijf_file($testfile);
	&maak_binair_test($outfile);
    }

}


if($algo eq "snow")
{
#nbrwords zegt gewoon hoeveel woorden er per regel staan.
#dus incl klasse! en hij telt vanaf 1 en de array loopt vanaf nul
    for $c (0 .. $nbrWords-2)
    {

	$field = $c+1;
	$tmp = `cut -d'$cut_scheider' -f$field  < $file |sort |uniq -c|sort -rn`;
	chomp($tmp);
	@ef_str = split /\n/,$tmp;
	$aantal_fvalues = $#ef_str + 1;

	@tmp = split /\s+/,$ef_str[0];
	$mfr_value = $tmp[2];

	#stel nu dat als 0 en 1 gecodeerd en 0 komt vaker voor
	#dan hetscript de boel nu omdraaien.dus checken:
	if( $mfr_value eq "0" && $aantal_fvalues eq "2")
	{
	    @tmp = split /\s+/,$ef_str[1];
	    if($tmp[2] eq "1")
	    {
		$mfr_value = $tmp[2];
	    }    
	}
	
	if($aantal_fvalues eq "2")
	{
	    $bin_houder[$c] = $mfr_value;

	}else{
	    $bin_houder[$c] = "-0-";
	}	
    }



    &herschrijf_file_snow($file);
    #lees key in
    open(LEX,"$file.$algo.key") || die " kan $file.$algo.key niet openen";
    while(<LEX>)
    {
	$line =$_;
	chomp($line);
	@array = split /\s+/, $line;
	$lexhash{$array[$#array]} = $array[0];
	$lexgrootte = $array[0];
    }
    close(LEX);
    
    #zet met key de outfile om in een binaire file
    &maak_binair($outfile);
    
    #als er een testfile is meegeven
    if($test)
    {
	&herschrijf_file_snow_test($testfile);
	&maak_binair_test($outfile);
     }
 
 
}


if($verbosity eq "0")
{
    system("rm -f $file.$algo.key $file.$algo.cod ");
    if($test){	system("rm -f $testfile.$algo.cod "); }
}


sub herschrijf_file{

    my $file = $_[0];    
    my $regelteller=0;
    my $nrwords=0;
    my @helezin=();

    $outfile = "$file.$algo.cod";
    system("rm -f $outfile");

    open(FILE,"$file") || die " kan $file niet openen";
    while(<FILE>)
    {
	
	$line =$_;
	chomp($line);
	@array = split /$scheider/,$line;
	$klasse = pop @array;
	open(OUTFILE,">>$outfile")||die "kan $outfile niet openen"; 

	print OUTFILE "$klasse ";
	for $x (0 .. $#array-1)
	{
	 
	    if( $bin_houder[$x] ne "-0-")
	    {
		if($array[$x] eq $bin_houder[$x])
		{
		    print OUTFILE "$x||$array[$x] ";
		}
	    }
	    else{
		print OUTFILE "$x||$array[$x] ";
	    }
	}
	print OUTFILE "$#array||$array[$#array]\n";
	
	close(OUTFILE);
	
    }
close(FILE);
}



sub herschrijf_file_snow{

    my $file = $_[0];    
    my $regelteller=0;
    my $nrwords=0;
    my @helezin=();
    my @array;
    my @klassen_array;
    my $x;

#in snow worden de klassen ook gehercodeerd
#met de eerste cijfers van het key-lexicon.

    $outfile = "$file.$algo.cod";
    system("rm -f $outfile");
    system("rm -f $file.key");

    open(FILE,"$file") || die " kan $file niet openen";
    while(<FILE>)
    {
	
	$line =$_;
	chomp($line);
	@array = split /$scheider/,$line;
	$klasse = pop @array;
	push @klassen_array, $klasse;

	open(OUTFILE,">>$outfile")||die "kan $outfile niet openen"; 

	print OUTFILE "$klasse ";
	
	for $x (0 .. $#array-1)
	{
	 
	    if( $bin_houder[$x] ne "-0-")
	    {
		if($array[$x] eq $bin_houder[$x])
		{
		    print OUTFILE "$x||$array[$x] ";
		}
	    }
	    else{
		print OUTFILE "$x||$array[$x] ";
	    }
	}
	print OUTFILE "$#array||$array[$#array]\n";
	
	close(OUTFILE);
	
}
close(FILE);

    #doe sort en uniq van klassen
    foreach( @klassen_array) 
    {
	unless($b{$_}++) 
	{
	    push(@uniq,$_);
	}
    }
   
    @sort_uniq = sort @uniq;
    
    #print eerst de klassen naar key
    open(LEXOUT,">>$file.$algo.key") || die " $file.key niet openen";
    for $x (0 ..$#sort_uniq)
    {
	print LEXOUT "$x $sort_uniq[$x]\n";
    }
    close(LEXOUT);

    #print de rest van features erachter
    $teller =$#sort_uniq;
    system("cut -d' ' -f2- < $outfile | tr -s ' ' '\\n' |sort|uniq   |sort -n |awk '{printf(\"\%d \%s\\n\",($teller+NR),\$0);}' >> $file.$algo.key");
}	
    
 

sub herschrijf_file_snow_test{

    my $file = $_[0];    
    my @helezin=();
    my @array;
    my @klassen_array;
    my $x;
    my $klasse=0;
     $outfile = "$file.$algo.cod";

    system("rm -f $outfile");


    open(FILE,"$file") || die " kan $file niet openen";
    while(<FILE>)
    {
	
	$line =$_;
	chomp($line);
	@array = split /$scheider/,$line;
	$klasse = pop @array;
	push @klassen_array, $klasse;

	open(OUTFILE,">>$outfile")||die "kan $outfile niet openen"; 

	print OUTFILE "$klasse ";

	for $x (0 .. $#array-1)
	{
	 
	    if( $bin_houder[$x] ne "-0-")
	    {
		if($array[$x] eq $bin_houder[$x])
		{
		    print OUTFILE "$x||$array[$x] ";
		}
	    }
	    else{
		print OUTFILE "$x||$array[$x] ";
	    }
	}
	print OUTFILE "$#array||$array[$#array]\n";

	close(OUTFILE);
	
    }
    close(FILE);
    
}


sub maak_binair{

    my $line;
    my @array;
    my $klasse;
    my @bin_inst;
    my @inst;
    my $Unum;
    my $vlag;
    #globaal gedefinieerd: $lexgrootte %lexhash

    $vlag=1;
#lees nu de instantiefile in
#en maak er een binaire file van.

    print STDERR "output is $file.$algo.bin\n";

    system("rm -f $file.$algo.bin");

    open(FILE,"$outfile") || die " kan $outfile niet openen";
    while(<FILE>)
    {
	@bin_inst =();
	
	$line =$_;
	chomp($line);   
	@array = split /\s+/, $line;
	#bij snow doet de klasse gewoon mee
	if($algo ne "snow")
	{	
	    $klasse = shift @array;
	}
	for $x ( 0 .. $#array)
	{
	    if(defined ($lexhash{$array[$x]}))
	    {
		push @bin_inst, $lexhash{$array[$x]};
	    }else{
		print STDERR "$array[$x] niet in lex! en dat kan niet in trainset!!!"; 
		exit(0);
	    }
	}
	# SVM eist nummieke volgorde, dus sorteer instantie!
	#Omdat de snows klassen de eerste elementen zijn, gaat dat ook goed
	@inst = sort {$a <=> $b} @bin_inst;
	open(OUTFILE2,">> $file.$algo.bin")|| die "kan $outfile.bin.ins niet openen";
       
	if($algo eq "snow")
	{
	    $str = join ",", @inst;
	    print OUTFILE2 "$str:\n";
	}
	else{
	    print OUTFILE2 "$klasse ",join ":1 ", @inst, "\n";
	}
	close(OUTFILE2);
    }
    close(FILE);
}






sub maak_binair_test{

    my $line;
    my @array;
    my $klasse;
    my @bin_inst;
    my @inst;
    my $Unum;
    my $vlag;
    #globaal: $lexgroote %lexhash

    $vlag=1;
#lees nu de instantiefile  in
#en maak er een binaire file van.

    print STDERR "output is $testfile.$algo.bin\n";

    system("rm -f $testfile.$algo.bin");

    open(FILE,"$outfile") || die " kan $outfile niet openen";
    while(<FILE>)
    {
	@bin_inst =();
	
	$line =$_;
	chomp($line);   
	@array = split /\s+/, $line;

	if($algo ne "snow")
	{	
	    $klasse = shift @array;
	}
	for $x ( 0 .. $#array)
	{
	    if(defined ($lexhash{$array[$x]}))
	    {
		push @bin_inst, $lexhash{$array[$x]};
	    }else{
		$Unum = $lexgrootte + 1 + $x;
		push @bin_inst,$Unum;
		if($vlag){  
		    #print STDERR "$array[$x] niet in lex! en krijgt $Unum\n"; 
		    $vlag=0;}
	    }
	}
	#sSVM eist nummieke volgorde, dus sorteer instantie!
	@inst = sort {$a <=> $b} @bin_inst;

	open(OUTFILE2,">> $testfile.$algo.bin")|| die "kan $outfile.bin.ins niet openen";
       
	if($algo eq "snow")
	{
	    for $x (0 ..$#inst-1)
	    {
		print OUTFILE2 "$inst[$x],";
	    }
	    print OUTFILE2 "$inst[$#inst]:\n";
	}
	else{
	    print OUTFILE2 "$klasse ",join ":1 ", @inst, "\n";
	}
	close(OUTFILE2);


    }
    close(FILE);
    
}

sub check_scheiding{


 my $file = $_[0]; 
 #my $nbrWords; <-- nu globaal
 my $scheider;

 $nbrWords = `head -n 1 < $file |wc -w`;
 chomp($nbrWords);

 if( $nbrWords < 2)
 {
     $scheider = ",";
     $cut_scheider = ",";
     $nbrWords = `head -n 1 < $file |tr ',' ' ' |wc -w`;
     chomp($nbrWords);
 }
 else{
     $cut_scheider = " ";
     $scheider = "\\s";
 }
 $nbrWords =~ m/\s+(\d+).*/;
 $nbrWords = $1;
# print "nbrWords : $nbrWords: :$scheider:\n";

 return $scheider;
}





#4feb 2004
#
#-1 script voor svms, maxent en snow.
#-checkt zelf of het fle door kommas of door spaties wordt gescheiden.
#
#28 juli 2003
# dit is een simpele versie.
#input is een timbl-instantie-file.
# Aanroep: perl make_maxent.simpel.pl trainfile ( testfile )
#daarvan wordt iedere kolom genummerd
# en weggeschreven zodat ieder woord als betekenis woord+positie heeft.
#hier maak je een lexicon-lijst van. 
#lexicon gebruik je om de strings om te zetten 
#in een binaire representatie.

#Output drie files:   
#-trainfile.cod(het tussenformatfile)  
#-trainfile.bin(het maxentfile)   
#-trainfile.key

#NB: voor svm moet de data nog wel gesplitst worden in binaire klassen!!
##########

#23 juni 2003
#deze doet niet zoals Yamcha,
#maar maakt een variabele voor ieder onbekend woord+positie
#

#20 mei 2003
#deze versie maakt precies hetzelfde format als YamCha.
#dat is nodig om een eerlijke vergelijking te kunnen maken.
# er is een variabele $kollie. deze var is niet zeer belangrijk, en vooral erg lastig, maar helaas zit het zo in YamCha.



#vlaggetje dat aangaat als er ook een testfile wordt meegegeven.
#testwoorden die niet in trainfile-lexicon zitten,
# worden gehercodeerd als [positie+unknown].

