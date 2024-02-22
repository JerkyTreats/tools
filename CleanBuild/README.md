## CleanBuild 

Unreal builds can corrupt when doing LiveCoding. Cleaning locally can help. 

I don't want to keep relearning how to do it, so this is a tool to do it for me. 

### Step 1: Nuke Generated Files 

Following the [UnrealDev Community Wiki](https://unrealcommunity.wiki/cleaning-your-project-d4s8khfl):

* Delete: 

    .vs

    Binaries

    DerivedDataCache

    Intermediate

    Plugins/*/Intermediate (any Intermediate folder inside a plugin)

    Saved ProjectName.sln (only if your project has a c++ code in it)


