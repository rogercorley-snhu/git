How Rooms are processed:
1. Checks to see if there is an 'AppendBed' key in the cfgOvheread table to append the Room and Bed together
2. If Room Separator is used:
 - If the Bed is blank, then just use the Room Number
 - Otherwise, append the bed to the room using the room separator (i.e., 501-A)
3. Checks the tblXLAT table to see if 'Room' xlatID exists
 - If 'Room' xlat entry exists, read the Keyout value for the Room Number being passed in from the interface
 - If the above does not exist, append the Bed to the Room Number (without the Append Bed character, i.e., 501A)
   and get the Keyout value
4. Look in the tblRoomOHD table and see if the Room Number from the interface exists


--Syntax:
SELECT dbo.RoomID(@RoomNumber, @Bed)

--Example:
SELECT dbo.RoomID('C101', '01')


Return Value:
Returns the RoomID from the tblRoomOHD
