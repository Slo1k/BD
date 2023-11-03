#!/bin/bash
# założenia:
#   (1) w katalogu bieżącym lokalnego systemu plików węzła master znajdują się
#       oprócz tego pliku (skryptu) także wszystkie inne pliki wchodzące w skład Twojego projektu (zawartość Twojego pliku projekt1.zip)
#   (2) w katalogu input znajdującym się w katalogu domowym użytkownika w systemie plików HDFS w katalogach podrzędnych
#       datasource1 oraz datasource4 znajdują się rozpakowane pliki źródłowego zestawu danych - zestaw danych (1) i (4)

echo " "
echo ">>>> usuwanie pozostałości po wcześniejszych uruchomieniach"
# usuwamy katalog output dla mapreduce (3)
if $(hadoop fs -test -d ./output_mr3) ; then hadoop fs -rm -f -r ./output_mr3; fi
# usuwamy katalog output dla ostatecznego wyniku projektu (6)
if $(hadoop fs -test -d ./output6) ; then hadoop fs -rm -f -r ./output6; fi
# usuwamy katalog plikami projektu (skryptami, plikami jar i wszystkim co musi być dostępne w HDFS do uruchomienia projektu)
if $(hadoop fs -test -d ./project_files) ; then hadoop fs -rm -f -r ./project_files; fi
# usuwamy lokalny katalog output zawierający ostateczny wynik projektu (6)
if $(test -d ./output6) ; then rm -rf ./output6; fi

echo " "
echo ">>>> kopiowanie skryptów, plików jar i wszystkiego co musi być dostępne w HDFS do uruchomienia projektu"
hadoop fs -mkdir -p  project_files
hadoop fs -mkdir -p  project_files/input/datasource1
hadoop fs -mkdir -p  project_files/input/datasource4
hadoop fs -copyFromLocal datasource1/*.csv project_files/input/datasource1
hadoop fs -copyFromLocal datasource4/*.csv project_files/input/datasource4
hadoop fs -copyFromLocal code/*.py project_files

echo " "
echo ">>>> uruchamianie zadania MapReduce - przetwarzanie (2)"
mapred streaming
-files code/mapper.py,code/combiner.py,code/reducer.py
-outputformat org.apache.hadoop.mapred.SequenceFileOutputFormat
-input project_files/input/datasource1
-output output_mr3
-mapper mapper.py
-combiner combiner.py
-reducer reducer.py

hadoop fs -copyToLocal ./output_mr3

echo " "
echo ">>>> uruchamianie skryptu Hive/Pig - przetwarzanie (5)"
hive -f project_files/transform5.hql -p output_dir6=output6 -p input_dir3=output_mr3 -p input_dir4=project_files/input/datasource4

echo " "
echo ">>>> pobieranie ostatecznego wyniku (6) z HDFS do lokalnego systemu plików"
mkdir -p ./output6
hadoop fs -copyToLocal output6/* ./output6

echo " "
echo " "
echo " "
echo " "
echo ">>>> prezentowanie uzyskanego wyniku (6)"
cat ./output6/*