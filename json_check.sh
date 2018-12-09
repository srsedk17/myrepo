perldoc -l JSON
if [ $? != 0 ]
then
tar xvf JSON-2.97001.tar.gz
cd JSON-2.97001
perl Makefile.PL
make
make install
fi 
