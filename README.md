# yotta-prom-graf


#Background


![Alt text](yottadb-graf.PNG?raw=true "YottaDB unit test runner Dashboard")

The code in this repo allows for the integration of a YottaDB environment with Prometheus/Grafana.

The solutions harnesses Yottadb's $ZJOBEXAM function to output environment debug/performance statistics to a file for conversion to a Prometheus "scraper" before metrics are displayed in Grafana.


# Use Case

A typical use case would be in the unit testing a Yottadb "backend" process as part of continuous integration pipeline. A baseline, tollerable profile of the process "footprint" can be charted against actual performance and visually assessed in Grafana 


# Prerequisites

It is assumed that you have a functioning deployment of both Prometheus and Grafana with Prometheus able to "scape" metrics and Grafana able to see the scraped metric through the Prometheus plugin.

The Prometheus-client Python library will also be required:

https://pypi.org/project/prometheus-client/0.0.9/

Ensure that the ydb executable is executable via the system path and so ensure that there is a symbolic link between the localised executable and one of the system paths i.e.

    ln -s /usr/local/yottadb/ydb /usr/local/bin/ydb


# Installation and Operation

    git clone https://github.com/RamSailopal/yotta-prom-graf.git
    cd yotta-prom-graf
    
Run the prometheus web scraper process with:
   
   ./ydbstat.sh 
   
This will ask you for the port to run the scraper on. To avoid this question, set the environmental variable YOTTA_PROM_PORT to the port required i.e.

    export YOTTA_PROM_PORT="8001"
    
Add the contents of prometheus.yml to your existing Prometheus configuration, changing the target address and port accordingly

Add the _TSTRUNNER.m routine to your existing YottaDB environment through adding it to the routines directory i.e:

     cp _TSTRUNNER.m /home/yottadbuser/.yottadb/r1.30_x86_64/r
     
Compile the routine within ydb:

     ZL "_TSTRUNNER.m"
     
As an optional step, you follow the same process for the example test runner routine:

     cp examples/TESTROUT.m /home/yottadbuser/.yottadb/r1.30_x86_64/r
     ZL "TESTROUT.m"
    
Run the test runner process with the a given routine i.e. the example routine:

     ./tstrunner.sh "GET^TESTROUT(5000)" 1 1
     
The first parameter is the line label and routine to run, the second parameter is whether to clear all existing JOBEXAM files or not (1 = yes, 0 = no) and the third parameter is whether to import a baseline profile.

A baseline profile example, exists as baseline/GET_TESTROUT and should always be named with the line label to be executed followed by a "_" and the routine to be executed.

The test runner example above will create 5000 GET calls and chart these against the baseline figures.


# Grafana

An example dashboard showing metrics relating to global sets, gets and orders, as in the example image can be shown by importing the dashboard file examples/Yottadb-grafana.json.

These are just 3 of the metrics that are scraped by Prometheus. Details of the full range of metrics can be found under the MNEMONICS/DESCRIPTION section here:

https://docs.yottadb.com/ProgrammersGuide/commands.html#zshow

The labels for each metric will display the job id of the test runner, the routine run by the test runner and the line label executed also.

    

    
