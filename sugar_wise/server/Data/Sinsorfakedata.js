const sinsorFakeData = [
  {
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    Gloucose: 95,
    Date: new Date("2026-04-12T08:30:00Z"),
    Time: "8:30 AM"
  },
  {
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    Gloucose: 140,
    Date: new Date("2026-04-12T12:45:00Z"),
    Time: "12:45 PM"
  },
  {
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    Gloucose: 110,
    Date: new Date("2026-04-12T19:15:00Z"),
    Time: "7:15 PM"
  },
  {
    Patient_Id: "PID_00002",
    Name: "Mahmoud Mohamed",
    Gloucose: 88,
    Date: new Date("2026-04-12T07:00:00Z"),
    Time: "7:00 AM"
  },
  {
    Patient_Id: "PID_00002",
    Name: "Mahmoud Mohamed",
    Gloucose: 155,
    Date: new Date("2026-04-12T13:30:00Z"),
    Time: "1:30 PM"
  },
  {
    Patient_Id: "PID_00003",
    Name: "Mona Ibrahim",
    Gloucose: 102,
    Date: new Date("2026-04-12T09:00:00Z"),
    Time: "9:00 AM"
  },
  {
    Patient_Id: "PID_00003",
    Name: "Mona Ibrahim",
    Gloucose: 125,
    Date: new Date("2026-04-12T21:00:00Z"),
    Time: "9:00 PM"
  },
  {
    Patient_Id: "PID_00004",
    Name: "Ali Youssef",
    Gloucose: 180,
    Date: new Date("2026-04-12T11:00:00Z"),
    Time: "11:00 AM"
  },
  {
    Patient_Id: "PID_00004",
    Name: "Ali Youssef",
    Gloucose: 210,
    Date: new Date("2026-04-12T16:20:00Z"),
    Time: "4:20 PM"
  },
  {
    Patient_Id: "PID_00005",
    Name: "Sara Hassan",
    Gloucose: 92,
    Date: new Date("2026-04-12T06:15:00Z"),
    Time: "6:15 AM"
  },
  {
    Patient_Id: "PID_00006",
    Name: "Mohamed Ali",
    Gloucose: 105,
    Date: new Date("2026-04-12T07:45:00Z"),
    Time: "7:45 AM"
  },
  {
    Patient_Id: "PID_00007",
    Name: "Nour Mohamed",
    Gloucose: 118,
    Date: new Date("2026-04-12T08:10:00Z"),
    Time: "8:10 AM"
  },
  {
    Patient_Id: "PID_00008",
    Name: "Omar Ibrahim",
    Gloucose: 145,
    Date: new Date("2026-04-12T20:30:00Z"),
    Time: "8:30 PM"
  },
  {
    Patient_Id: "PID_00009",
    Name: "Aya Youssef",
    Gloucose: 99,
    Date: new Date("2026-04-12T07:30:00Z"),
    Time: "7:30 AM"
  },
  {
    Patient_Id: "PID_00010",
    Name: "Ahmed Hassan",
    Gloucose: 132,
    Date: new Date("2026-04-12T12:00:00Z"),
    Time: "12:00 PM"
  },
  {
    Patient_Id: "PID_00011",
    Name: "Layla Ali",
    Gloucose: 108,
    Date: new Date("2026-04-12T09:45:00Z"),
    Time: "9:45 AM"
  },
  {
    Patient_Id: "PID_00012",
    Name: "Mahmoud Mohamed",
    Gloucose: 165,
    Date: new Date("2026-04-12T14:15:00Z"),
    Time: "2:15 PM"
  },
  {
    Patient_Id: "PID_00013",
    Name: "Mona Ibrahim",
    Gloucose: 96,
    Date: new Date("2026-04-12T06:50:00Z"),
    Time: "6:50 AM"
  },
  {
    Patient_Id: "PID_00014",
    Name: "Ali Youssef",
    Gloucose: 142,
    Date: new Date("2026-04-12T10:10:00Z"),
    Time: "10:10 AM"
  },
  {
    Patient_Id: "PID_00015",
    Name: "Sara Hassan",
    Gloucose: 115,
    Date: new Date("2026-04-12T18:40:00Z"),
    Time: "6:40 PM"
  },
  {
    Patient_Id: "PID_00016",
    Name: "Mohamed Ali",
    Gloucose: 190,
    Date: new Date("2026-04-12T13:00:00Z"),
    Time: "1:00 PM"
  },
  {
    Patient_Id: "PID_00017",
    Name: "Nour Mohamed",
    Gloucose: 122,
    Date: new Date("2026-04-12T07:15:00Z"),
    Time: "7:15 AM"
  },
  {
    Patient_Id: "PID_00018",
    Name: "Omar Ibrahim",
    Gloucose: 138,
    Date: new Date("2026-04-12T11:45:00Z"),
    Time: "11:45 AM"
  },
  {
    Patient_Id: "PID_00019",
    Name: "Aya Youssef",
    Gloucose: 101,
    Date: new Date("2026-04-12T22:15:00Z"),
    Time: "10:15 PM"
  },
  {
    Patient_Id: "PID_00020",
    Name: "Ahmed Hassan",
    Gloucose: 147,
    Date: new Date("2026-04-12T15:30:00Z"),
    Time: "3:30 PM"
  },
  {
    Patient_Id: "PID_00001",
    Name: "Layla Ali",
    Gloucose: 120,
    Date: new Date("2026-04-11T20:00:00Z"),
    Time: "8:00 PM"
  },
  {
    Patient_Id: "PID_00002",
    Name: "Mahmoud Mohamed",
    Gloucose: 98,
    Date: new Date("2026-04-11T07:30:00Z"),
    Time: "7:30 AM"
  },
  {
    Patient_Id: "PID_00003",
    Name: "Mona Ibrahim",
    Gloucose: 135,
    Date: new Date("2026-04-11T12:15:00Z"),
    Time: "12:15 PM"
  },
  {
    Patient_Id: "PID_00004",
    Name: "Ali Youssef",
    Gloucose: 205,
    Date: new Date("2026-04-11T16:00:00Z"),
    Time: "4:00 PM"
  },
  {
    Patient_Id: "PID_00005",
    Name: "Sara Hassan",
    Gloucose: 89,
    Date: new Date("2026-04-11T06:30:00Z"),
    Time: "6:30 AM"
  },
  {
    Patient_Id: "PID_00006",
    Name: "Mohamed Ali",
    Gloucose: 112,
    Date: new Date("2026-04-11T21:45:00Z"),
    Time: "9:45 PM"
  },
  {
    Patient_Id: "PID_00007",
    Name: "Nour Mohamed",
    Gloucose: 128,
    Date: new Date("2026-04-11T08:50:00Z"),
    Time: "8:50 AM"
  },
  {
    Patient_Id: "PID_00008",
    Name: "Omar Ibrahim",
    Gloucose: 152,
    Date: new Date("2026-04-11T13:20:00Z"),
    Time: "1:20 PM"
  },
  {
    Patient_Id: "PID_00009",
    Name: "Aya Youssef",
    Gloucose: 104,
    Date: new Date("2026-04-11T07:15:00Z"),
    Time: "7:15 AM"
  },
  {
    Patient_Id: "PID_00010",
    Name: "Ahmed Hassan",
    Gloucose: 139,
    Date: new Date("2026-04-11T19:50:00Z"),
    Time: "7:50 PM"
  },
  {
    Patient_Id: "PID_00021",
    Name: "Layla Ali",
    Gloucose: 114,
    Date: new Date("2026-04-12T08:45:00Z"),
    Time: "8:45 AM"
  },
  {
    Patient_Id: "PID_00022",
    Name: "Mahmoud Mohamed",
    Gloucose: 172,
    Date: new Date("2026-04-12T14:30:00Z"),
    Time: "2:30 PM"
  },
  {
    Patient_Id: "PID_00023",
    Name: "Mona Ibrahim",
    Gloucose: 99,
    Date: new Date("2026-04-12T07:20:00Z"),
    Time: "7:20 AM"
  },
  {
    Patient_Id: "PID_00024",
    Name: "Ali Youssef",
    Gloucose: 155,
    Date: new Date("2026-04-12T11:30:00Z"),
    Time: "11:30 AM"
  },
  {
    Patient_Id: "PID_00025",
    Name: "Sara Hassan",
    Gloucose: 102,
    Date: new Date("2026-04-12T19:15:00Z"),
    Time: "7:15 PM"
  },
  {
    Patient_Id: "PID_00026",
    Name: "Mohamed Ali",
    Gloucose: 185,
    Date: new Date("2026-04-12T13:45:00Z"),
    Time: "1:45 PM"
  },
  {
    Patient_Id: "PID_00027",
    Name: "Nour Mohamed",
    Gloucose: 126,
    Date: new Date("2026-04-12T08:00:00Z"),
    Time: "8:00 AM"
  },
  {
    Patient_Id: "PID_00028",
    Name: "Omar Ibrahim",
    Gloucose: 142,
    Date: new Date("2026-04-12T20:10:00Z"),
    Time: "8:10 PM"
  },
  {
    Patient_Id: "PID_00029",
    Name: "Aya Youssef",
    Gloucose: 105,
    Date: new Date("2026-04-12T07:40:00Z"),
    Time: "7:40 AM"
  },
  {
    Patient_Id: "PID_00030",
    Name: "Ahmed Hassan",
    Gloucose: 140,
    Date: new Date("2026-04-12T15:15:00Z"),
    Time: "3:15 PM"
  },
  {
    Patient_Id: "PID_00031",
    Name: "Layla Ali",
    Gloucose: 111,
    Date: new Date("2026-04-11T20:30:00Z"),
    Time: "8:30 PM"
  },
  {
    Patient_Id: "PID_00032",
    Name: "Mahmoud Mohamed",
    Gloucose: 94,
    Date: new Date("2026-04-11T07:50:00Z"),
    Time: "7:50 AM"
  },
  {
    Patient_Id: "PID_00033",
    Name: "Mona Ibrahim",
    Gloucose: 130,
    Date: new Date("2026-04-11T12:45:00Z"),
    Time: "12:45 PM"
  },
  {
    Patient_Id: "PID_00034",
    Name: "Ali Youssef",
    Gloucose: 195,
    Date: new Date("2026-04-11T16:30:00Z"),
    Time: "4:30 PM"
  },
  {
    Patient_Id: "PID_00035",
    Name: "Sara Hassan",
    Gloucose: 85,
    Date: new Date("2026-04-11T06:45:00Z"),
    Time: "6:45 AM"
  }
];

module.exports = sinsorFakeData;
