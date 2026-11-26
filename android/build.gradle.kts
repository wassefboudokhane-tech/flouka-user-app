allprojects {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

rootProject.buildDir = File("../build")

subprojects {
    buildDir = File("${rootProject.buildDir}/${this.name}")
}
subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
