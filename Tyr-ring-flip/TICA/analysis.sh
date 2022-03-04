for i in {1..40}; do
cd Run${i}
#rm -r Analysis
mkdir Analysis
cd Analysis
cp ../../ts_detect.py .
cp ../COLVAR-tyr .
sed -e '/SET/d' COLVAR-tyr > xxx
sed 's/#! FIELDS/ /' xxx >  edt_COLVAR
echo "Simulation $i"
python ts_detect.py
echo ""
cd ../..
done
