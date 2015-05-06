/*
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
------------------------------------------------------------------------------------------------------------------
*/




/*
------------------------------------------------------------------------------------------------------------------
[ STORED PROCEDURE : CycleXLAT_NEW        ]                              
------------------------------------------------------------------------------------------------------------------

USE [GEMdb]
GO

DECLARE @return_value int

EXEC  @return_value = [dbo].[sp_CycleXLATnew]
    @CoreID = 1,
    @XlatID = N'< Enter XlatID Here >',
    @BeginDate = N'< Enter EndDate of Last Cycle Here >',
    @NumCycles = < Enter Number of Cycles Desired Here >,
    @Freq = N'< Enter Cycle Frequecy Code Here e.g. W02 >',
    @CycleNo = < Find the Last CycleNo and Increase by 1 - Enter Here >

SELECT  'Return Value' = @return_value

GO