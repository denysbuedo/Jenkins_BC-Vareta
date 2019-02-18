/*
@Autor: Denys Buedo Hidalgo
@Proyecto: Jenkins_Freesurfer (https://github.com/denysbuedo/Jenkins_Freesurfer.git)
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
	def eeg = "${parser.attribute("EEG")}"
	def leadfield ="${parser.attribute("LeadField")}"
    def surface ="${parser.attribute("Surface")}"
	def scalp="${parser.attribute("Scalp")}"
	
	//Setting Build description
	currentBuild.displayName = "BUILD# $build_ID-$owner_name"
	
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
			sh 'ssh -o StrictHostKeyChecking=no root@192.168.17.132'
			sh "scp $data_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $eeg_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $leadfield_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $surface_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $scalp_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			
			//--- Remove data file in job workspace ---
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$data.txt"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$eeg"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$leadfield"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$surface"
			sh "rm -f $JENKINS_HOME/jobs/BC-Vareta/builds/$build_ID/fileParameters/$scalp"
        } 
	}
  
	stage('DATA PROCESSING (BC-Vareta)'){
  
	}
  
	stage('DATA DELIVERY'){

	}
  
	stage('NOTIFICATION AND REPORT'){
    
	}

}
