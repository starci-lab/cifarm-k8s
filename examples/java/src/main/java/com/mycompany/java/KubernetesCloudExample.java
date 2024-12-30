/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.java;

import java.io.IOException;
import java.util.Collections;

import jenkins.model.*;
import org.csanchez.jenkins.plugins.kubernetes.*;
/**
 *
 * @author cuong
 */
public class KubernetesCloudExample {

    public static void main(String[] args) throws IOException {
        var jenkins = Jenkins.get();
        
        var kubernetesCloud = new KubernetesCloud("cifarm-kubernetes");
        kubernetesCloud.setNamespace("jenkins");
        kubernetesCloud.setSkipTlsVerify(true);
        kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local");
        kubernetesCloud.setWebSocket(true);
        jenkins.clouds.add(kubernetesCloud);
        jenkins.save();

        var podTemplate = new PodTemplate();
        podTemplate.setName("Kaniko Agent");
        podTemplate.setYaml("");
        podTemplate.setLabel("kaniko");
        podTemplate.setNamespace("jenkins");
        podTemplate.setNodeSelector("jenkins.io/kaniko=true");
        podTemplate.setNodeSelector("jenkins.io/kaniko=true");
        var containerTemplate =  new ContainerTemplate(
            "kaniko",
            "gcr.io/kaniko-project/executor:latest"
        );
        containerTemplate.setAlwaysPullImage(true);
        containerTemplate.setWorkingDir("/home/jenkins/agent");
        containerTemplate.setCommand("cat");
        containerTemplate.setArgs("999999");
        containerTemplate.setResourceRequestCpu("180m");
        containerTemplate.setResourceRequestMemory("360Mi");
        containerTemplate.setResourceLimitCpu("540m");
        containerTemplate.setResourceLimitMemory("1080Mi");
        podTemplate.setContainers(Collections.singletonList(
            containerTemplate
        ));
    }
}
