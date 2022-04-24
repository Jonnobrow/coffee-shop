#!/usr/bin/env groovy
/**
 * Full Terraform Pipeline
 *
 * @param Map params
 *
 * Usage:
 *
 * @Library('jonnobrow') _
 *
 * Pipeline([envs: ['dev01', 'dev02', 'dev03', 'dev04']]) */
def call(Map params = [:]) {

    def defaultParams = [
        envs: []
    ]

    final Map finalParams = defaultParams << params

    node {
        Terraform([command: 'init', targets: finalParams.envs, initUpgrade: true ])
        Terraform([command: 'apply', targets: finalParams.envs ])
    }
}
