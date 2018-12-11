#!/usr/bin/perl
use JSON;
`export http_proxy='http://svc_Mobile_testing:!2Characters@eudc1proxy.internal.ecomp.com:8080';
my (%purge_progress,%purge_status);
my $url_purge='https://api.ccu.akamai.com/ccu/v2/queues/default';
my $url_purge_status='https://api.ccu.akamai.com/ccu/v2/purges';

sub help {
print " Parameter should not be empty\n";
print " pass the first parameter as prod or static1\n";
print " prod - is  furge cache key for production\n";
print " static1 - is furge cache key for static1\n";
############
print " pass the second parameter akamai user name\n";
print " eg: example@rs-components.com\n";
print "pass Third parameter as akamai user password\n";
}

if (!$ARGV[0] or !$ARGV[1] or !$ARGV[2] or !($ARGV[0] =~ /prod|static1/)){
help();
exit;
}

sub purge_st{
$p_id=shift @_;
chomp $p_id;
$username=shift @_;
chomp $username;
$passwd=shift @_;
chomp $passwd;
$purge_out=`curl -s $url_purge_status/$p_id -u $username:$passwd`;
$status= decode_json($purge_out);
%purge_status=%{$status};
return $purge_status{'purgeStatus'};
}

if ($ARGV[0] =~ /static1/){
@object_key=('"S/L/14833/425240/28d/product-page-bundles-ui.web-preprod.nonprod.rscomp.systems/web/static/product/product-bundles/js/product-bundles.js","S/L/14833/425240/28d/product-page-bundles-ui.web-preprod.nonprod.rscomp.systems/web/static/product/product-bundles/css/product-bundles.css","S/D/14833/425240/000/product-page-bundles-ui.web-preprod.nonprod.rscomp.systems/web/static/product"');
}
if ($ARGV[0] =~ /prod/){
@object_key=('"S/L/14870/425222/28d/product-page-bundles-ui.web.prod.rscomp.systems/web/static/product/product-bundles/js/product-bundles.js","S/L/14870/425222/28d/product-page-bundles-ui.web.prod.rscomp.systems/web/static/product/product-bundles/css/product-bundles.css","S/D/14870/425222/000/product-page-bundles-ui.web.prod.rscomp.systems/web/static/product"');
}

$username = $ARGV[1];
$passwd = $ARGV[2];
$out_json=`curl -s $url_purge -H "Content-Type:application/json" -d '{"objects":[@object_key],"action":"invalidate","type":"arl","domain":"production"}' -u $username:$passwd`;
my $out_hash= decode_json($out_json);
%purge_progress=%{$out_hash};
print "$purge_progress{'purgeId'}\n";

$p_status=purge_st($purge_progress{'purgeId'},$username,$passwd);

while($p_status=~ /In-Progress/){
print "Purge status is : $p_status\n";
$p_status=purge_st($purge_progress{'purgeId'},$username,$passwd);
sleep 60;
}
if ($p_status=~ /Done/){
print "Purge status is : Success";}
