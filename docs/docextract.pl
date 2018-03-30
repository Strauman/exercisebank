#!/usr/bin/perl
use strict;
use warnings;
# Examples:
#%\BDOC
#%§VariableForASection=My section name
#%\macroname[oarg]{marg}{marg}
#%Description goes
#%here and then you do
#%\EDOC
#%\BDOC
#%§VariableForASection
#%\begin{env}[oarg1]{marg}
#% This environment also does something
#% that is amazing!
#%\EDOC

# Config
my $output = "documentation.tex";
my $input = "$ARGV[0]";
my $macroTemplateFile = "templates/macrodef.tex";
my $skeletonTemplateFile = "templates/docskeleton.tex";
my $envTemplateFile = "templates/envdef.tex";
my $exampleTemplateFile = "templates/exampletemplate.tex";
my $mainSection="Reference";
my $toFile = 1;
my $sectionHeader = "\\subsection{§section}\n";
my @sectionOrder = ("§makingSets", "§env", "§lang", "§triggers", "§ref");
# File loading
sub talk
{
  my ($words) = @_;
	print STDERR "$words";
}
# Main in/out
if ($toFile==1){
  open (my $OUTPUT, '>', "$output") or die $!;
  STDOUT->fdopen(\*$OUTPUT, 'w') or die $!;
}

open(my $FILE, "<", $input) or die "could not open input file '$input'\n";

# Template files
sub loadTemplate
{
  my ($templateFile)=@_;
  local $/ = undef;
  open FILE, $templateFile or die "Couldn't open file: $!";
  binmode FILE;
  my $outTemplate = <FILE>;
  close FILE;
  return $outTemplate
}
my $macroTemplate = loadTemplate($macroTemplateFile);
my $envTemplate=loadTemplate($envTemplateFile);
my $exampleTemplate=loadTemplate($exampleTemplateFile);
my $skeleton=loadTemplate($skeletonTemplateFile);

# Strings for output
my $docOutString="";
my $priorityOutString="";
my $currentTemplate="";
my $description="";
my $example="";
my $triggers="";
# Saving (variables/sections)
my %sections;
my %prioritySections;
my %variables;

# States
my $capturestate=0; # \BDOC \EDOC
my $descriptionstate=0;
my $examplestate=0;
my $prioritystate=0;

# Patterns
my $pOarg=qr/(?:\[(?<oarg>.*?)\])?/;
my $pMargs=qr/(?=(?<margs>(?:{[^}]*})*))?/;
my $pStyleArgs=qr/(?:\[(?<styleArgs>.*?)\])?/;
# Macros
my $pMacro=qr/\\(?!EDOC)(?<macroname>[a-zA-Z]+)/;
my $macroPattern=qr/^[%]+\s*${pMacro}${pOarg}${pMargs}${pStyleArgs}/;
# Environment
my $pEnv=qr/\\\\begin\{(?<envname>[^\}]+)\}/;
my $envPattern=qr/^[%]\s*+${$pEnv}${pOarg}${pMargs}${pStyleArgs}/;
# Other globals
my $line;
# Replacing macros with \dac
my $dacSearch=qr/\\((?!(?:dac|oarg|marg|meta|refCom|brackets|refEnv))[a-zA-Z]+)/;
# my $dacSearch=qr//;
my $bracketSearch=qr/\\(?!(?:dac|oarg|marg|meta|refCom|brackets|refEnv))[a-zA-Z]+\K\{([^\}]+)\}/;

my $currentSection=$mainSection;
sub addToSection{
  my ($content) = @_;
  if(!exists $sections{$currentSection}){
    $sections{$currentSection}="";
    $prioritySections{$currentSection}="";
  }
  if($prioritystate==1){
    $prioritySections{$currentSection}.="$content\n";
  }else{
    $sections{$currentSection}.="$content\n";
  }
}

sub variableHandler
{
  # Variable definition §§asdf=asdf
  if(/^\s*[%]+\s*§(?<varname>[^\s=]+)+(?:=(?<assigned>.*))?/){
    if(!$+{assigned}){
      if(exists $variables{$+{varname}}){
        $currentSection=$variables{$+{varname}};
        return 1;
      }
      else{
        $currentSection="§$1";
        return 1;
      }
    }
    else{
      talk("Setting $+{varname}=$+{assigned}\n");
      $variables{$+{varname}}=$+{assigned};
      $currentSection=$+{assigned};
      return 1;
    }
  }
  else{
    return 0;
  }
}

sub extractMacro
{
  # Look for macro syntax.
  # Macros containing @ is not included
  # /$macroPattern/;
  # talk "$+{macroname}\n";
  # talk "$+{oarg}\n";
  # talk "$+{margs}\n";
  my $margs = $+{margs};
  my $oargs = $+{oarg};
  my $macroname = $+{macroname};
  my $styleArgs = $+{styleArgs};
  $margs =~ s/(\{[^\}]*\})/\\marg$1/g;
  # talk "OA";
  # print $oargs;
  # talk ($oargs==0);
  if($oargs){
    $oargs = "\\oarg{$oargs}";
  }
  else{
    $oargs="";
  }
  $currentTemplate = $macroTemplate =~ s/§margs/$margs/r;
  $currentTemplate =~ s/§oargs/$oargs/;
  $currentTemplate =~ s/§mname/$macroname/;
  if(!$styleArgs){
    $styleArgs="";
  }
  $currentTemplate =~ s/§style/$styleArgs/;
  $descriptionstate=1;
}
sub extractEnv
{
  # Look for \newenvironment
  # Macros containing @ is not included
  # /$macroPattern/;
  # talk "$+{envname}\n";
  # talk "$+{oarg}\n";
  # talk "$+{margs}\n";
  my $margs = $+{margs};
  my $oargs = $+{oarg};
  my $envname = $+{envname};
  my $styleArgs = $+{styleArgs};
  if(!$styleArgs){
    $styleArgs="";
  }
  if(!$oargs){
    $oargs="";
  }else{
    $oargs = "\\oarg{$oargs}";
  }
  $margs =~ s/(\{[^\}]*\})/\\marg$1/g;
  $currentTemplate = $envTemplate =~ s/§margs/$margs/r;
  $currentTemplate =~ s/§oargs/$oargs/;
  $currentTemplate =~ s/§envname/$envname/;
  $currentTemplate =~ s/§style/$styleArgs/;
  $descriptionstate=1;
}
sub extractDesc
{
  if(/^[%]+\s*\\EDOC!?/){
    $capturestate=0;
    $descriptionstate=0;
    $currentTemplate =~ s/§description/$description/;
    addToSection($currentTemplate);
    # if($prioritystate==1){
    #   $priorityOutString.=$currentTemplate;
    # }else{
    #   $docOutString.=$currentTemplate;
    # }
    $prioritystate=0;
    $currentTemplate="";
    $description="";
  }elsif(s/^[%]+(.*)//){
    $_= $line;
    s/$bracketSearch/\\\{$1\\\}/g;
    s/$dacSearch/\\dac{$1}/g;
    # Remove backslash from \\asdf
    # (Double backslash will be just transfered as macro)
    s/\\!([a-zA-Z@]+)/\\$1/g;
    s/^\s*[%]+(.*)/$1/;
    $description.=$_;
  }
}
sub extractExample
{
  if(/^[%]+\s*\\EEX!?/){
    $examplestate=0;
    $currentTemplate = $exampleTemplate;
    $currentTemplate =~ s/§content/$example/;
    $currentTemplate =~ s/§style//;
    addToSection($currentTemplate);
    # if($prioritystate==1){
    #   $priorityOutString.=$currentTemplate;
    # }else{
    #   $docOutString.=$currentTemplate;
    # }
    $prioritystate=0;
    $currentTemplate="";
    $example="";
  }elsif(s/^%(.*)//){
    $_= $line;
    s/^\s*[%]+(.*)/$1/;
    # s/$bracketSearch/\\\{$1\\\}/g;
    # s/$dacSearch/\\dac{$1}/g;
    # s/(?:\s|\})\K\{([^\}]+)\}/\\\{$1\\\}/g;
    $example.="$_\n";
  }
}

sub extractDoc
{
  $_=$line;
  # Variable usage §asdf
  if($descriptionstate==1){
    extractDesc();
  }
  elsif(/$macroPattern/){
    extractMacro();
  }
  elsif(/$envPattern/){
    extractEnv();
  }else{
    $currentTemplate = "§description\n";
    $descriptionstate=1;
    extractDesc();
  }
}
sub sumstates{
  $capturestate+$examplestate;
}

while ($line = <$FILE>) {
  $_=$line;
  # Ignore if line does not start with comment
  if(/^[^%]/){
    next;
  }
  # Remove pdflatex comments: %!
  if(s/^%!.*//){
    next;
  }
  if(/^[%]+\s*\\BDOC(?!!)/){
    $capturestate=1;
    $prioritystate=0;
    next;
  }
  elsif(variableHandler()){
    next;
  }
  elsif(/^[%]+\s*\\BDOC!/){
    $capturestate=1;
    $prioritystate=1;
    next;
  }elsif(/^[%]\s*\\BEX(?!!)/){
    $prioritystate=0;
    $examplestate=1;
    next;
  }
  elsif(/^[%]\s*\\BEX!/){
    $examplestate=1;
    $prioritystate=1;
    next;
  }
  elsif($capturestate==1){
    extractDoc();
  }elsif($examplestate==1){
    extractExample();
  }elsif(/^[ \s\t]*[%]+\s*\\Trigger\\([a-zA-Z]+):(.*)/){
    $triggers.="\\dac{At}\\dac{$1}\\\\ $2\\\\\n";
  }

}
keys %prioritySections; # reset the internal iterator so a prior each() doesn't affect the loop
foreach (@sectionOrder)
{
      my $sec=$_;
      if(/^§(.*)/){
        if (exists $variables{$1}){
            $sec=$variables{$1};
        }else{
          talk "Section order uses undefined variable §$1\n";
        }
      }
      talk "Generating section $sec\n";
      if(exists $prioritySections{$sec} && exists $sections{$sec}){
        $docOutString.= $sectionHeader=~ s/§section/$sec/r;
        $docOutString.=$prioritySections{$sec};
        $docOutString.=$sections{$sec};
        delete $prioritySections{$sec};
        delete $sections{$sec};
      }
}
keys %prioritySections;
while(my($sec, $cont) = each %prioritySections) {
  talk "Generating section $sec\n";
  $docOutString.= $sectionHeader=~ s/§section/$sec/r;
  $docOutString.=$cont;
  $docOutString.=$sections{$sec};
}

$docOutString =~ s/!!triggers/$triggers/;
$docOutString = $skeleton =~ s/§content/$docOutString/r;
print $docOutString;
