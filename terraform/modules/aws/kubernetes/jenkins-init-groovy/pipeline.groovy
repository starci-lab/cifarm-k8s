// Adds a pipeline job to Jenkins

import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import org.jenkinsci.plugins.workflow.flow.FlowDefinition
import hudson.plugins.git.GitSCM
import hudson.plugins.git.BranchSpec
import hudson.plugins.git.UserRemoteConfig
import java.util.Collections
import com.cloudbees.jenkins.GitHubPushTrigger
import org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty

// Required plugins:
// - git
// - workflow-multibranch

// Variables
String jobName = "${job_name}"  // Job name
String jobDescription = "${job_description}"  // Job description
String jobScriptPath = "${job_script_path}"  // Path to the Jenkinsfile in the repository
String gitRepo = "${git_repo}"  // Git repository URL
String gitRepoName = "origin"  // Remote name, e.g., "origin"
String gitRepoBranch = "${git_repo_branch}"  // Branch pattern, e.g., "*/main" or "*"
String credentialsId = ""     // Leave empty if no credentials are required

// Get Jenkins instance
Jenkins jenkins = Jenkins.get()  // Correct way to get Jenkins instance

// Create the Git configuration
UserRemoteConfig userRemoteConfig = new UserRemoteConfig(gitRepo, gitRepoName, null, credentialsId)

// Branch specification (all branches or a specific one)
List<BranchSpec> branches = Collections.singletonList(new BranchSpec(gitRepoBranch))

// Define additional Git configuration (optional, can be left as null if not needed)
boolean doGenerateSubmoduleConfigurations = false
List submoduleCfg = null
Object browser = null
String gitTool = null
List extensions = []

// Create GitSCM object
GitSCM scm = new GitSCM(
    [userRemoteConfig],                     // Repositories (Remote config)
    branches,                               // Branches
    doGenerateSubmoduleConfigurations,      // Generate submodule configurations
    submoduleCfg,                           // Submodule configurations (optional)
    browser,                                // Browser (optional)
    gitTool,                                // Git tool (optional)
    extensions                              // Git extensions (optional)
)

// Create the pipeline flow definition
FlowDefinition flowDefinition = new CpsScmFlowDefinition(scm, jobScriptPath)

// Check if the job already exists
WorkflowJob job = jenkins.getItemByFullName(jobName)

// Add the DisableConcurrentBuildsJobProperty to the job
DisableConcurrentBuildsJobProperty disableConcurrentBuildsJobProperty = new DisableConcurrentBuildsJobProperty()
disableConcurrentBuildsJobProperty.setAbortPrevious(true)
job.addProperty(disableConcurrentBuildsJobProperty)

// Create and configure the job
job = jenkins.createProject(WorkflowJob.class, jobName)
job.setDefinition(flowDefinition)
job.setDescription(jobDescription)

// Add GitHub webhook trigger
job.addTrigger(new GitHubPushTrigger())
// Add SCM polling trigger
// job.addTrigger(new SCMTrigger("H/5 * * * *"))

// Save the job
job.save()

// Print success message
println "Pipeline job '$${jobName}' has been created successfully!"
