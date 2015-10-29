package imagga;

use WWW::Curl;
use WWW::Curl::Easy;
import WWW::Curl::Easy;
use WWW::Curl::Form;

sub write_callback { 
    my ($chunk,$variable)=@_; 
    push @{$variable}, $chunk; 
    return length($chunk); 
} 


sub new
{
	my $class = shift;
	my $self = {
		apiKey => shift,
		apiSecret => shift,
		endPoint => 'http://api.imagga.com/v1'
	};
	bless $self, $class;
	return $self;
}

sub tag_image
{
	my $self = shift;
	$filePath = shift;
	
	my ( $err, $id ) = $self->file_upload($filePath);
	
	if( $err == 0)
	{
		return $self->tag_contentid($id);
	}
	
	return (3, "")
}


sub file_upload
{
	my $self = shift;
	$filePath = shift;
	
	$ret_html = $self->http("/content", "POST", $filePath);
	
	if($ret_html =~ m/.*"id": "([0-9a-z]*)",.*/g)
	{
		$id = $1;	
		return (0, $id);
	}
	return (2, "");
}

sub tag_contentid
{
	my $self = shift;
	$id = shift;

	my ($err, $ret_html) = $self->http("/tagging", "GET", $id);
	
		my $hash = {};
	
	if($err != 0)
	{
		return ($err, $hash);
	}
	
	while($ret_html =~ /"confidence": ([0-9.a-z]*),\s*"tag": "(\w*)"/g)
	{
		$hash->{$2} = $1;
	}

    
    return (0, $hash);
}

sub http
{
	my $self = shift;
	$uri = shift;
	$method = shift;
	$param = shift;
	
	$apiKey = $self->{apiKey};
	$apiSecret = $self->{apiSecret};
	$endPoint = $self->{endPoint};
	
	$url = $endPoint . $uri;
	
	if($method eq "GET")
	{
		$url = $url . "?content=" . $param;
	}
	
	my $curlf = WWW::Curl::Form->new;
	my $curl = WWW::Curl::Easy->new or die $!;
	
	
	$curl->setopt(CURLOPT_HEADERFUNCTION, \&write_callback); 
	$curl->setopt(CURLOPT_WRITEFUNCTION, \&write_callback); 

	my (@head,@body); 
	$curl->setopt(CURLOPT_HTTPHEADER, \@head); 
	$curl->setopt(CURLOPT_FILE, \@body); 
	
	$curl->setopt(CURLOPT_URL, $url);
	$curl->setopt(CURLOPT_CUSTOMREQUEST, $method);
	$curl->setopt(CURLOPT_RETURNTRANSFER, 1);
	$curl->setopt(CURLOPT_CONNECTTIMEOUT, 5);
	$curl->setopt(CURLOPT_TIMEOUT, 60);
	$curl->setopt(CURLOPT_USERAGENT, 'Imagga Perl SDK');
	$curl->setopt(CURLOPT_USERPWD, $apiKey . ':' . $apiSecret);

	if($method eq "POST")
	{
		$curlf->formaddfile($param, 'image', "multipart/form-data");
		$curl->setopt(CURLOPT_POST, 1);
		$curl->setopt(CURLOPT_HTTPPOST, $curlf);
	}
	
	$curl->setopt(CURLOPT_HEADER, [
		'Accept: application/json',
		'Content-Type: application/json'
	]);

	my $retcode = $curl->perform();
	my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);

	if($retcode != 0)
	{
		print("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
		return (1, "");
	}

	my $body=join("",@body); 

	return (0, $body);
	
}    
1;
