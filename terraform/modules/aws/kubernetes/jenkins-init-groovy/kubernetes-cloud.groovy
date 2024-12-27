// Import necessary classes
import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud
import org.csanchez.jenkins.plugins.kubernetes.PodTemplate
import org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate

// templates
def requestCpu = "${request_cpu}"
def requestMemory = "${request_memory}"
def limitCpu = "${limit_cpu}"
def limitMemory = "${limit_memory}"
def nodeSelector = "${node_selector}"
def namespace = "${namespace}"

// Define the cloud name
def cloudName = "cifarm-kubernetes"
// Define the Jenkins instance
def jenkins = Jenkins.get()  // Using Jenkins.get() for newer Jenkins versions

// Check if the Kubernetes cloud already exists
if (jenkins.clouds.find { it.name == cloudName }) {
    // Print confirmation
    println "Kubernetes cloud '$${cloudName}' already exists in Jenkins."
    // Skip the rest of the script
    return
}

// Create the KubernetesCloud configuration
def kubernetesCloud = new KubernetesCloud(cloudName)  // Name of the Kubernetes cloud configuration
kubernetesCloud.setNamespace(namespace)                         // Kubernetes namespace
kubernetesCloud.setSkipTlsVerify(true)                          // Skip TLS verification (true if you want to disable it)
kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local") // Jenkins internal URL in Kubernetes
kubernetesCloud.setWebSocket(true)                              // Use WebSocket for communication with Jenkins agents

// Create pod templates
def podTemplate = new PodTemplate()
podTemplate.setName("Kaniko Agent")
podTemplate.setLabel("kaniko-agent")  // Label for the pod template
podTemplate.setNamespace(namespace)
podTemplate.setNodeSelector(nodeSelector) // Node selector for the pod template

// Create the container template for building
// ==========================================
def containerTemplate = new ContainerTemplate(
    "kaniko",  // Container name
    "gcr.io/kaniko-project/executor:debug"  // Container image
)
// Configure container options
containerTemplate.setAlwaysPullImage(true)  // Always pull the image
containerTemplate.setCommand("/busybox/sleep")  // Set the command to run
containerTemplate.setArgs("infinity")  // Set the arguments for the command
containerTemplate.setResourceRequestCpu(requestCpu)  // Request CPU resources
containerTemplate.setResourceRequestMemory(requestMemory)  // Request Memory resources
containerTemplate.setResourceLimitCpu(limitCpu)  // Set CPU resource limits
containerTemplate.setResourceLimitMemory(limitMemory)  // Set Memory resource limits

// Add the container template to the pod template
podTemplate.setContainers(Collections.singletonList(containerTemplate))
// ==========================================

// Add the pod template to the Kubernetes cloud configuration
kubernetesCloud.addTemplate(podTemplate)

// Add the Kubernetes cloud configuration to Jenkins
jenkins.clouds.add(kubernetesCloud)

// Save the Jenkins configuration
jenkins.save()

// Print confirmation
println "Kubernetes cloud '$${cloudName}' has been successfully added to Jenkins."
