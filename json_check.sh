perldoc -l JSON
if [ $? != 0 ]
then
tar xvf JSON-2.97001.tar.gz
sleep 5
cd JSON-2.97001
perl Makefile.PL
make
sleep 5
make install
sleep 10
if [ $? = 0 ]
then
echo "JSON module installed\n"
fi
else
echo "JSON module existing\n"
fi
