/// Tests for the BI package
Class samplesbi.unittests.TestBI Extends %UnitTest.TestCase
{

/// Pivots test
Method TestPivots()
{
     Do $$$AssertStatusOK(##class(dev.bi).checkAllPivots(),"Test Pivots")
}

/// Test dashboards in BI package
Method TestDashboards()
{
     Do $$$AssertStatusOK(##class(dev.bi).checkDashboards(),"Test Dashboards")
}

}

