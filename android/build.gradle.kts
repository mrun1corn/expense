allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        val isAndroid = plugins.hasPlugin("com.android.application") || 
                        plugins.hasPlugin("com.android.library")
        if (isAndroid) {
            extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
                compileSdkVersion(36)
                if (namespace == null) {
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        try {
                            val parser = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder()
                            val doc = parser.parse(manifestFile)
                            val pkg = doc.documentElement.getAttribute("package")
                            if (pkg.isNotEmpty()) {
                                namespace = pkg
                            }
                        } catch (e: Exception) {
                            namespace = "com.example.${project.name.replace("_", ".")}"
                        }
                    } else {
                        namespace = "com.example.${project.name.replace("_", ".")}"
                    }
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
