/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.java;

import jenkins.model.*;
import org.csanchez.jenkins.plugins.kubernetes.*;
/**
 *
 * @author cuong
 */
public class KubernetesCloudExample {

    public static void main(String[] args) {
        var jenkins = Jenkins.getInstance();
        
        var kubernetesCloud = new KubernetesCloud("cifarm-kubernetes", null, null, "jenkins", null, "10", 5, 10, 5);
        kubernetesCloud.setSkipTlsVerify(true);
        kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local");
        kubernetesCloud.setWebSocket(true);
        jenkins.clouds.add(kubernetesCloud);
        jenkins.save();
    }
}
