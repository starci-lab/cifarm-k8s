// Import necessary classes
import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud

// Define the Jenkins instance
Jenkins jenkins = Jenkins.get()  // Using Jenkins.get() for newer Jenkins versions

// Check if the Kubernetes cloud configuration already exists
def cloudName = "cifarm-kubernetes"
def existingCloud = jenkins.clouds.find { it.name == cloudName }

if (existingCloud) {
    // If the cloud exists, print a message and skip creation
    println "Kubernetes cloud '${cloudName}' already exists in Jenkins. Skipping creation."
} else {
    // Create the KubernetesCloud configuration if it doesn't exist
    KubernetesCloud kubernetesCloud = new KubernetesCloud(cloudName)  // Name of the Kubernetes cloud configuration
    kubernetesCloud.setNamespace("jenkins")                         // Kubernetes namespace
    kubernetesCloud.setSkipTlsVerify(true)                          // Skip TLS verification (true if you want to disable it)
    kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local") // Jenkins internal URL in Kubernetes
    kubernetesCloud.setWebSocket(true)                              // Use WebSocket for communication with Jenkins agents

    // Add the Kubernetes cloud configuration to Jenkins
    jenkins.clouds.add(kubernetesCloud)

    // Save the Jenkins configuration
    jenkins.save()

    // Print confirmation
    println "Kubernetes cloud '${cloudName}' has been successfully added to Jenkins."
}
