/*
@Autor: Denys Buedo Hidalgo
@Proyecto: BC-Vareta Method (https://github.com/denysbuedo/Jenkins_BC-Vareta.git)
@Joint China-Cuba Laboratory
@Universidad de las Ciencias Informaticas
*/

node{

  	//--- Getting the upstream build number
    echo "Reading the build parent number"
    def manualTrigger = true
  	def upstreamBuilds = ""
  	currentBuild.upstreamBuilds?.each {b ->
    	upstreamBuilds = "${b.getDisplayName()}"
    	manualTrigger = false
  	}
  	def xml_name = "$upstreamBuilds" + ".xml"
  	
  	//--- Reading current job config ---
	echo "Reading the job config"
  	def job_config = readFile "$JENKINS_HOME/jobs/BC-Vareta/builds/QueueJobs/$xml_name"
	def parser = new XmlParser().parseText(job_config)
	def job_name = "${parser.attribute("job")}"
	def build_ID ="${parser.attribute("build")}"
	def owner_name ="${parser.attribute("name")}"
	def notif_email ="${parser.attribute("email")}"
	def eeg = "${parser.attribute("EEG")}"
	def leadfield ="${parser.attribute("LeadField")}"
    def surface ="${parser.attribute("Surface")}"
	def scalp="${parser.attribute("Scalp")}"
	
	//Setting Build description
	def currentBuildName = "BUILD#$build_ID-$owner_name"
	currentBuild.displayName = "$currentBuildName"
	
	stage('CHECKOUT CODE (BC-Vareta)'){
	
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github_dbuedo-id', url: 'https://github.com/denysbuedo/BC-VARETA-toolbox-master.git']]])
    }
		
	stage('DATA ACQUISITION'){
  		
  		//--- Starting ssh agent on Matlab server ---
		sshagent(['fsf_id_rsa']) {      
			
			//--- Creating de data file ---
			def data_file =  new File  ("$JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/data.txt")
			def eeg_file =  new File  ("$JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$eeg")
			def leadfield_file =  new File  ("$JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$leadfield")
			def surface_file =  new File  ("$JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$surface")
			def scalp_file =  new File  ("$JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$scalp")
			
			//--- Copying de data file to External_data folder in Matlab Server --- 
			sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.129'
			sh "scp $data_file root@192.168.17.129:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run"
			sh "scp $eeg_file root@192.168.17.129:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/"
			sh "scp $leadfield_file root@192.168.17.129:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/"
			sh "scp $surface_file root@192.168.17.129:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/"
			sh "scp $scalp_file root@192.168.17.129:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/"
			
			echo "Voy a borrar workspace"
			//--- Remove data file in job workspace ---
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/data.txt"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$eeg"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$leadfield"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$surface"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$scalp"
        } 
        
        
	}
  
	stage('DATA PROCESSING (BC-Vareta)'){
  		
  		//--- Starting ssh agent on Matlab Server ---
		sshagent(['fsf_id_rsa']) { 
		
			/*--- Goal: Execute the matlab command, package and copy the results in the FTP server and clean the workspace.  
			@file: jenkins.sh
        	@Parameter{
    			$1-action [run, delivery]
        		$2-Name of the person who run the task ($owner_name)
        		$3-EEG file ($eeg)
        		$4-LeadField ($leadfield)
        		$5-Surface ($surface)
        		$6-Scalp ($scalp) 
			} ---*/           
       		echo "--- Run Matlab command ---"
        	sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.129'
        	sh "ssh root@192.168.17.129 /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/jenkins.sh run $owner_name $eeg $leadfield $surface $scalp $currentBuildName"	
		}
	}
  
	stage('DATA DELIVERY'){
		
		//--- Starting ssh agent on Matlab Server ---
		sshagent(['fsf_id_rsa']) { 
		
			/*--- Goal: Execute the matlab command, package and copy the results in the FTP server and clean the workspace.  
			@file: jenkins.sh
        	@Parameter{
    			$1-action [run, delivery]
        		$2-Name of the person who run the task ($owner_name)
        		$3-EEG file ($eeg)
        		$4-LeadField ($leadfield)
        		$5-Surface ($surface)
        		$6-Scalp ($scalp) 
			} ---*/           
       		echo "--- Tar and copy files result to FTP Server ---"
        	sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.129'
        	sh "ssh root@192.168.17.129 /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/jenkins.sh delivery $owner_name $eeg $leadfield $surface $scalp $currentBuildName"	
		}
	}
  
	stage('NOTIFICATION AND REPORT'){
    	
    	//--- Sending notification email ---//
//    	emailext (
//   		subject: "Job $JOB_NAME ${env.BUILD_NUMBER}'",
//    		body: """<p> Done!!! </p>""",
//    		to: "$notif_email",
//    		from: "buedo@neuroinformatics-collaboratory.org"
//		)
    	
    	//--- Inserting data in influxdb database ---/
		step([$class: 'InfluxDbPublisher', customData: null, customDataMap: null, customPrefix: null, target: 'influxdb'])
	}

}
