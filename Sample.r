/*
#
#	Apple Macintosh Developer Technical Support
#
#	MultiFinder-Aware Simple Sample Application
#
#	Sample
#
#	Sample.r	-	Rez Source
#
#	Copyright © 1989 Apple Computer, Inc.
#	All rights reserved.
#
#	Versions:	
#				1.00				08/88
#				1.01				11/88
#				1.02				04/89	MPW 3.1
#
#	Components:
#				Sample.p			April 1, 1989
#				Sample.c			April 1, 1989
#				Sample.a			April 1, 1989
#				Sample.inc1.a		April 1, 1989
#				SampleMisc.a		April 1, 1989
#				Sample.r			April 1, 1989
#				Sample.h			April 1, 1989
#				[P]Sample.make		April 1, 1989
#				[C]Sample.make		April 1, 1989
#				[A]Sample.make		April 1, 1989
#
#	Sample is an example application that demonstrates how to
#	initialize the commonly used toolbox managers, operate 
#	successfully under MultiFinder, handle desk accessories, 
#	and create, grow, and zoom windows.
#
#	It does not by any means demonstrate all the techniques 
#	you need for a large application. In particular, Sample 
#	does not cover exception handling, multiple windows/documents, 
#	sophisticated memory management, printing, or undo. All of 
#	these are vital parts of a normal full-sized application.
#
#	This application is an example of the form of a Macintosh 
#	application; it is NOT a template. It is NOT intended to be 
#	used as a foundation for the next world-class, best-selling, 
#	600K application. A stick figure drawing of the human body may 
#	be a good example of the form for a painting, but that does not 
#	mean it should be used as the basis for the next Mona Lisa.
#
#	We recommend that you review this program or TESample before 
#	beginning a new application.
*/

#include "Types.r"
#include "Sample.h"

/* this is a definition for a resource which contains only a rectangle */
type 'RECT' {
	rect;
};


/* we use an MBAR resource to conveniently load all the menus */

resource 'MBAR' (rMenuBar, preload) {
	{ mApple, mFile, mEdit, mLight, mHelp };	/* five menus */
};


resource 'MENU' (mApple, preload) {
	mApple, textMenuProc,
	AllItems & ~MenuItem2,	/* Disable dashed line, enable About and DAs */
	enabled, apple,
	{
		"About Sample",
			noicon, nokey, nomark, plain;
		"-",
			noicon, nokey, nomark, plain
	}
};

resource 'MENU' (mFile, preload) {
	mFile, textMenuProc,
	MenuItem12,				/* enable Quit only, program enables others */
	enabled, "File",
	{
		"New",
			noicon, "N", nomark, plain;
		"Open",
			noicon, "O", nomark, plain;
		"-",
			noicon, nokey, nomark, plain;
		"Close",
			noicon, "W", nomark, plain;
		"Save",
			noicon, "S", nomark, plain;
		"Save As",
			noicon, nokey, nomark, plain;
		"Revert",
			noicon, nokey, nomark, plain;
		"-",
			noicon, nokey, nomark, plain;
		"Page Setup",
			noicon, nokey, nomark, plain;
		"Print",
			noicon, nokey, nomark, plain;
		"-",
			noicon, nokey, nomark, plain;
		"Quit",
			noicon, "Q", nomark, plain
	}
};

resource 'MENU' (mEdit, preload) {
	mEdit, textMenuProc,
	NoItems,				/* disable everything, program does the enabling */
	enabled, "Edit",
	 {
		"Undo",
			noicon, "Z", nomark, plain;
		"-",
			noicon, nokey, nomark, plain;
		"Cut",
			noicon, "X", nomark, plain;
		"Copy",
			noicon, "C", nomark, plain;
		"Paste",
			noicon, "V", nomark, plain;
		"Clear",
			noicon, nokey, nomark, plain
	}
};

resource 'MENU' (mLight, preload) {
	mLight, textMenuProc,
	NoItems,				/* disable everything, program does the enabling */
	enabled, "Traffic",
	 {
		"Red Light",
			noicon, nokey, nomark, plain;
		"Green Light",
			noicon, nokey, nomark, plain
	}
};

resource 'MENU' (mHelp, preload) {
	mHelp, textMenuProc,
	AllItems,				/* disable everything, program does the enabling */
	enabled, "Help",
	 {
		"Quick Help",
			noicon, nokey, nomark, plain;
		"User Guide",
			noicon, nokey, nomark, plain;
        "Test Entry",
			noicon, nokey, nomark, plain;
        "Test Entry 2",
			noicon, nokey, nomark, plain;
        "Test Entry 3",
			noicon, nokey, nomark, plain;
	}
};

/* this ALRT and DITL are used as an About screen */
resource 'ALRT' (rAboutAlert, purgeable) {
	{40, 20, 160, 290},
	rAboutAlert,
	{ /* array: 4 elements */
		/* [1] */
		OK, visible, silent,
		/* [2] */
		OK, visible, silent,
		/* [3] */
		OK, visible, silent,
		/* [4] */
		OK, visible, silent
	},
    centerMainScreen       // Where to show the alert
};

resource 'DITL' (rAboutAlert, purgeable) {
	{ /* array DITLarray: 5 elements */
		/* [1] */
		{88, 180, 108, 260},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{8, 8, 24, 214},
		StaticText {
			disabled,
			"Simple Sample (Traffic Light)"
		},
		/* [3] */
		{32, 8, 48, 237},
		StaticText {
			disabled,
			"Copyright © 1989 Apple Computer"
		},
		/* [4] */
		{56, 8, 72, 136},
		StaticText {
			disabled,
			"Brought to you by:"
		},
		/* [5] */
		{80, 24, 112, 167},
		StaticText {
			disabled,
			"Macintosh Developer Technical Support"
		}
	}
};


/* this ALRT and DITL are used as an error screen */

resource 'ALRT' (rUserAlert, purgeable) {
	{40, 20, 120, 260},
	rUserAlert,
	{ /* array: 4 elements */
		/* [1] */
		OK, visible, silent,
		/* [2] */
		OK, visible, silent,
		/* [3] */
		OK, visible, silent,
		/* [4] */
		OK, visible, silent
	},
    centerMainScreen       // Where to show the alert
};


resource 'DITL' (rUserAlert, purgeable) {
	{ /* array DITLarray: 3 elements */
		/* [1] */
		{50, 150, 70, 230},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{10, 60, 30, 230},
		StaticText {
			disabled,
			"Sample - Error occurred!"
		},
		/* [3] */
		{8, 8, 40, 40},
		Icon {
			disabled,
			2
		}
	}
};


resource 'WIND' (rWindow, preload, purgeable) {
	{39, 1, 341, 511},
	zoomDocProc, visible, noGoAway, 0x0, "Test",
    centerMainScreen       // Where to show the alert
};

resource 'RECT' (rStopRect, preload, purgeable) {
	{69, 69, 110, 110}
};

resource 'RECT' (rXRect, preload, purgeable) {
	{32, 32, 69, 69}
};

resource 'RECT' (rGoRect, preload, purgeable) {
	{120, 10, 220, 110}
};


/* here is the quintessential MultiFinder friendliness device, the SIZE resource */

resource 'SIZE' (-1) {
	dontSaveScreen,
	acceptSuspendResumeEvents,
	enableOptionSwitch,
	canBackground,				/* we can background; we don't currently, but our sleep value */
								/* guarantees we don't hog the Mac while we are in the background */
	multiFinderAware,			/* this says we do our own activate/deactivate; don't fake us out */
	backgroundAndForeground,	/* this is definitely not a background-only application! */
	dontGetFrontClicks,			/* change this is if you want "do first click" behavior like the Finder */
	ignoreChildDiedEvents,		/* essentially, I'm not a debugger (sub-launching) */
	not32BitCompatible,			/* this app should not be run in 32-bit address space */
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	kPrefSize * 1024,
	kMinSize * 1024	
};

data 'PICT' (150) {
	$"0278 0000 0000 003F 003F 1101 0100 0A00"            /* .x.....?.?....�. */
	$"0000 0000 3F00 3FA0 0082 A000 8E98 0008"            /* ....?.?�.��.��.. */
	$"0000 0000 003F 003F 0000 0000 003F 003F"            /* .....?.?.....?.? */
	$"0000 0000 003F 003F 0000 06FC 0002 3F00"            /* .....?.?...�..?. */
	$"0006 FC00 02FF C000 07FD 0003 01FF E000"            /* ..�..��..�...��. */
	$"07FD 0003 03E1 F000 07FD 0003 079E 7800"            /* .�...��..�...�x. */
	$"07FD 0003 0F61 BC00 07FD 0003 1E80 5E00"            /* .�...a�..�...�^. */
	$"07FD 0003 3D00 2F00 07FD 0003 7A00 1780"            /* .�..=./..�..z..� */
	$"07FD 0003 F400 0BC0 08FE 0004 01E8 0005"            /* .�..�..�.�...�.. */
	$"E008 FE00 0403 D000 02F0 08FE 0004 07A0"            /* �.�...�..�.�...� */
	$"0001 7808 FE00 040F 4000 00BC 08FE 0004"            /* ..x.�...@..�.�.. */
	$"1E80 0000 5C08 FE00 003D FE00 005E 08FE"            /* .�..\.�..=�..^.� */
	$"0000 7AFE 0000 2E08 FE00 00F4 FE00 002E"            /* ..z�....�..��... */
	$"0903 0000 01E8 FE00 002E 0903 0000 03D0"            /* �....��...�....� */
	$"FE00 002E 0907 0000 07A0 0100 005E 0907"            /* �...�....�...^�. */
	$"0000 0F40 0380 005C 0907 0000 1E80 01C0"            /* ...@.�.\�....�.� */
	$"00BC 0907 0000 3D00 08E0 0178 0907 0000"            /* .��...=..�.x�... */
	$"7A00 1C70 02F0 0907 0000 F400 0E38 05E0"            /* z..p.��...�..8.� */
	$"0907 0001 E800 E758 0BC0 0907 0003 D001"            /* �...�.�X.��...�. */
	$"F388 1780 0907 0007 A003 3810 2F00 0907"            /* �.��...�.8./.�. */
	$"000F 4002 5C60 5E00 0907 001E 8002 8C00"            /* ..@.\`^.�...�.�. */
	$"BC00 0907 003D 0010 C801 7800 0907 007A"            /* �.�..=..�.x.�..z */
	$"0110 F002 F000 0907 00F4 0390 6005 E000"            /* ..�.�.�..�.�`.�. */
	$"0907 01E8 01D0 000B C000 0907 03D0 00FF"            /* �..�.�..�.�..�.� */
	$"8017 8000 0905 07A0 1E70 002F FF00 0905"            /* �.�.�..�.p./�.�. */
	$"0F40 3738 005E FF00 0905 1E80 239C 00BC"            /* .@78.^�.�..�#�.� */
	$"FF00 0905 3D00 31C8 0178 FF00 0905 7A00"            /* �.�.=.1�.x�.�.z. */
	$"38C0 02F0 FF00 0905 7400 1C40 05E0 FF00"            /* 8�.��.�.t..@.��. */
	$"0905 F400 0EC0 0BC0 FF00 0905 E800 0780"            /* �.�..�.��.�.�..� */
	$"1780 FF00 0800 E8FE 0000 2FFE 0008 00E8"            /* .��...��../�...� */
	$"FE00 005E FE00 0800 E8FE 0000 BCFE 0008"            /* �..^�...��..��.. */
	$"04F4 0000 0178 FE00 0804 7400 0002 F0FE"            /* .�...x�...t...�� */
	$"0008 047A 0000 05E0 FE00 0804 3D00 000B"            /* ...z...��...=... */
	$"C0FE 0008 041E 8000 1780 FE00 0703 0F40"            /* ��....�..��....@ */
	$"002F FD00 0703 07A0 005E FD00 0703 03D0"            /* ./�....�.^�....� */
	$"00BC FD00 0703 01E8 0178 FD00 0703 00F4"            /* .��....�.x�....� */
	$"02F0 FD00 0703 007B 0DE0 FD00 0703 003C"            /* .��....{.��....< */
	$"F3C0 FD00 0703 001F 0F80 FD00 0602 000F"            /* ���......��..... */
	$"FFFC 0006 0200 07FE FC00 0602 0001 F8FC"            /* ��.....��.....�� */
	$"00A0 008F A000 83FF"                                /* .�.��.�� */
};

data 'PICT' (153) {
	$"3B5A 0000 0000 0064 0174 0011 02FF 0C00"            /* ;Z.....d.t...�.. */
	$"FFFF FFFF 0000 0000 0000 0000 0174 0000"            /* ����.........t.. */
	$"0064 0000 0000 0000 00A0 0082 001E 0001"            /* .d.......�.�.... */
	$"000A 0000 0000 0064 0174 0098 8174 0000"            /* .�.....d.t.��t.. */
	$"0000 0064 0174 0000 0000 0000 0000 0048"            /* ...d.t.........H */
	$"0000 0048 0000 0000 0008 0001 0008 0000"            /* ...H............ */
	$"0000 0000 3438 0000 0000 0000 4E0D 8000"            /* ....48......N.�. */
	$"00FF 0000 FFFF FFFF FFFF 0000 FFFF FFFF"            /* .�..������..���� */
	$"CCCC 0000 FFFF FFFF 9999 0000 FFFF FFFF"            /* ��..������..���� */
	$"6666 0000 FFFF FFFF 3333 0000 FFFF FFFF"            /* ff..����33..���� */
	$"0000 0000 FFFF CCCC FFFF 0000 FFFF CCCC"            /* ....������..���� */
	$"CCCC 0000 FFFF CCCC 9999 0000 FFFF CCCC"            /* ��..���̙�..���� */
	$"6666 0000 FFFF CCCC 3333 0000 FFFF CCCC"            /* ff..����33..���� */
	$"0000 0000 FFFF 9999 FFFF 0000 FFFF 9999"            /* ....������..���� */
	$"CCCC 0000 FFFF 9999 9999 0000 FFFF 9999"            /* ��..������..���� */
	$"6666 0000 FFFF 9999 3333 0000 FFFF 9999"            /* ff..����33..���� */
	$"0000 0000 FFFF 6666 FFFF 0000 FFFF 6666"            /* ....��ff��..��ff */
	$"CCCC 0000 FFFF 6666 9999 0000 FFFF 6666"            /* ��..��ff��..��ff */
	$"6666 0000 FFFF 6666 3333 0000 FFFF 6666"            /* ff..��ff33..��ff */
	$"0000 0000 FFFF 3333 FFFF 0000 FFFF 3333"            /* ....��33��..��33 */
	$"CCCC 0000 FFFF 3333 9999 0000 FFFF 3333"            /* ��..��33��..��33 */
	$"6666 0000 FFFF 3333 3333 0000 FFFF 3333"            /* ff..��3333..��33 */
	$"0000 0000 FFFF 0000 FFFF 0000 FFFF 0000"            /* ....��..��..��.. */
	$"CCCC 0000 FFFF 0000 9999 0000 FFFF 0000"            /* ��..��..��..��.. */
	$"6666 0000 FFFF 0000 3333 0000 FFFF 0000"            /* ff..��..33..��.. */
	$"0000 0000 CCCC FFFF FFFF 0000 CCCC FFFF"            /* ....������..���� */
	$"CCCC 0000 CCCC FFFF 9999 0000 CCCC FFFF"            /* ��..������..���� */
	$"6666 0000 CCCC FFFF 3333 0000 CCCC FFFF"            /* ff..����33..���� */
	$"0000 0000 CCCC CCCC FFFF 0000 CCCC CCCC"            /* ....������..���� */
	$"CCCC 0000 CCCC CCCC 9999 0000 CCCC CCCC"            /* ��..���̙�..���� */
	$"6666 0000 CCCC CCCC 3333 0000 CCCC CCCC"            /* ff..����33..���� */
	$"0000 0000 CCCC 9999 FFFF 0000 CCCC 9999"            /* ....�̙���..�̙� */
	$"CCCC 0000 CCCC 9999 9999 0000 CCCC 9999"            /* ��..�̙���..�̙� */
	$"6666 0000 CCCC 9999 3333 0000 CCCC 9999"            /* ff..�̙�33..�̙� */
	$"0000 0000 CCCC 6666 FFFF 0000 CCCC 6666"            /* ....��ff��..��ff */
	$"CCCC 0000 CCCC 6666 9999 0000 CCCC 6666"            /* ��..��ff��..��ff */
	$"6666 0000 CCCC 6666 3333 0000 CCCC 6666"            /* ff..��ff33..��ff */
	$"0000 0000 CCCC 3333 FFFF 0000 CCCC 3333"            /* ....��33��..��33 */
	$"CCCC 0000 CCCC 3333 9999 0000 CCCC 3333"            /* ��..��33��..��33 */
	$"6666 0000 CCCC 3333 3333 0000 CCCC 3333"            /* ff..��3333..��33 */
	$"0000 0000 CCCC 0000 FFFF 0000 CCCC 0000"            /* ....��..��..��.. */
	$"CCCC 0000 CCCC 0000 9999 0000 CCCC 0000"            /* ��..��..��..��.. */
	$"6666 0000 CCCC 0000 3333 0000 CCCC 0000"            /* ff..��..33..��.. */
	$"0000 0000 9999 FFFF FFFF 0000 9999 FFFF"            /* ....������..���� */
	$"CCCC 0000 9999 FFFF 9999 0000 9999 FFFF"            /* ��..������..���� */
	$"6666 0000 9999 FFFF 3333 0000 9999 FFFF"            /* ff..����33..���� */
	$"0000 0000 9999 CCCC FFFF 0000 9999 CCCC"            /* ....������..���� */
	$"CCCC 0000 9999 CCCC 9999 0000 9999 CCCC"            /* ��..���̙�..���� */
	$"6666 0000 9999 CCCC 3333 0000 9999 CCCC"            /* ff..����33..���� */
	$"0000 0000 9999 9999 FFFF 0000 9999 9999"            /* ....������..���� */
	$"CCCC 0000 9999 9999 9999 0000 9999 9999"            /* ��..������..���� */
	$"6666 0000 9999 9999 3333 0000 9999 9999"            /* ff..����33..���� */
	$"0000 0000 9999 6666 FFFF 0000 9999 6666"            /* ....��ff��..��ff */
	$"CCCC 0000 9999 6666 9999 0000 9999 6666"            /* ��..��ff��..��ff */
	$"6666 0000 9999 6666 3333 0000 9999 6666"            /* ff..��ff33..��ff */
	$"0000 0000 9999 3333 FFFF 0000 9999 3333"            /* ....��33��..��33 */
	$"CCCC 0000 9999 3333 9999 0000 9999 3333"            /* ��..��33��..��33 */
	$"6666 0000 9999 3333 3333 0000 9999 3333"            /* ff..��3333..��33 */
	$"0000 0000 9999 0000 FFFF 0000 9999 0000"            /* ....��..��..��.. */
	$"CCCC 0000 9999 0000 9999 0000 9999 0000"            /* ��..��..��..��.. */
	$"6666 0000 9999 0000 3333 0000 9999 0000"            /* ff..��..33..��.. */
	$"0000 0000 6666 FFFF FFFF 0000 6666 FFFF"            /* ....ff����..ff�� */
	$"CCCC 0000 6666 FFFF 9999 0000 6666 FFFF"            /* ��..ff����..ff�� */
	$"6666 0000 6666 FFFF 3333 0000 6666 FFFF"            /* ff..ff��33..ff�� */
	$"0000 0000 6666 CCCC FFFF 0000 6666 CCCC"            /* ....ff����..ff�� */
	$"CCCC 0000 6666 CCCC 9999 0000 6666 CCCC"            /* ��..ff�̙�..ff�� */
	$"6666 0000 6666 CCCC 3333 0000 6666 CCCC"            /* ff..ff��33..ff�� */
	$"0000 0000 6666 9999 FFFF 0000 6666 9999"            /* ....ff����..ff�� */
	$"CCCC 0000 6666 9999 9999 0000 6666 9999"            /* ��..ff����..ff�� */
	$"6666 0000 6666 9999 3333 0000 6666 9999"            /* ff..ff��33..ff�� */
	$"0000 0000 6666 6666 FFFF 0000 6666 6666"            /* ....ffff��..ffff */
	$"CCCC 0000 6666 6666 9999 0000 6666 6666"            /* ��..ffff��..ffff */
	$"6666 0000 6666 6666 3333 0000 6666 6666"            /* ff..ffff33..ffff */
	$"0000 0000 6666 3333 FFFF 0000 6666 3333"            /* ....ff33��..ff33 */
	$"CCCC 0000 6666 3333 9999 0000 6666 3333"            /* ��..ff33��..ff33 */
	$"6666 0000 6666 3333 3333 0000 6666 3333"            /* ff..ff3333..ff33 */
	$"0000 0000 6666 0000 FFFF 0000 6666 0000"            /* ....ff..��..ff.. */
	$"CCCC 0000 6666 0000 9999 0000 6666 0000"            /* ��..ff..��..ff.. */
	$"6666 0000 6666 0000 3333 0000 6666 0000"            /* ff..ff..33..ff.. */
	$"0000 0000 3333 FFFF FFFF 0000 3333 FFFF"            /* ....33����..33�� */
	$"CCCC 0000 3333 FFFF 9999 0000 3333 FFFF"            /* ��..33����..33�� */
	$"6666 0000 3333 FFFF 3333 0000 3333 FFFF"            /* ff..33��33..33�� */
	$"0000 0000 3333 CCCC FFFF 0000 3333 CCCC"            /* ....33����..33�� */
	$"CCCC 0000 3333 CCCC 9999 0000 3333 CCCC"            /* ��..33�̙�..33�� */
	$"6666 0000 3333 CCCC 3333 0000 3333 CCCC"            /* ff..33��33..33�� */
	$"0000 0000 3333 9999 FFFF 0000 3333 9999"            /* ....33����..33�� */
	$"CCCC 0000 3333 9999 9999 0000 3333 9999"            /* ��..33����..33�� */
	$"6666 0000 3333 9999 3333 0000 3333 9999"            /* ff..33��33..33�� */
	$"0000 0000 3333 6666 FFFF 0000 3333 6666"            /* ....33ff��..33ff */
	$"CCCC 0000 3333 6666 9999 0000 3333 6666"            /* ��..33ff��..33ff */
	$"6666 0000 3333 6666 3333 0000 3333 6666"            /* ff..33ff33..33ff */
	$"0000 0000 3333 3333 FFFF 0000 3333 3333"            /* ....3333��..3333 */
	$"CCCC 0000 3333 3333 9999 0000 3333 3333"            /* ��..3333��..3333 */
	$"6666 0000 3333 3333 3333 0000 3333 3333"            /* ff..333333..3333 */
	$"0000 0000 3333 0000 FFFF 0000 3333 0000"            /* ....33..��..33.. */
	$"CCCC 0000 3333 0000 9999 0000 3333 0000"            /* ��..33..��..33.. */
	$"6666 0000 3333 0000 3333 0000 3333 0000"            /* ff..33..33..33.. */
	$"0000 0000 0000 FFFF FFFF 0000 0000 FFFF"            /* ......����....�� */
	$"CCCC 0000 0000 FFFF 9999 0000 0000 FFFF"            /* ��....����....�� */
	$"6666 0000 0000 FFFF 3333 0000 0000 FFFF"            /* ff....��33....�� */
	$"0000 0000 0000 CCCC FFFF 0000 0000 CCCC"            /* ......����....�� */
	$"CCCC 0000 0000 CCCC 9999 0000 0000 CCCC"            /* ��....�̙�....�� */
	$"6666 0000 0000 CCCC 3333 0000 0000 CCCC"            /* ff....��33....�� */
	$"0000 0000 0000 9999 FFFF 0000 0000 9999"            /* ......����....�� */
	$"CCCC 0000 0000 9999 9999 0000 0000 9999"            /* ��....����....�� */
	$"6666 0000 0000 9999 3333 0000 0000 9999"            /* ff....��33....�� */
	$"0000 0000 0000 6666 FFFF 0000 0000 6666"            /* ......ff��....ff */
	$"CCCC 0000 0000 6666 9999 0000 0000 6666"            /* ��....ff��....ff */
	$"6666 0000 0000 6666 3333 0000 0000 6666"            /* ff....ff33....ff */
	$"0000 0000 0000 3333 FFFF 0000 0000 3333"            /* ......33��....33 */
	$"CCCC 0000 0000 3333 9999 0000 0000 3333"            /* ��....33��....33 */
	$"6666 0000 0000 3333 3333 0000 0000 3333"            /* ff....3333....33 */
	$"0000 0000 0000 0000 FFFF 0000 0000 0000"            /* ........��...... */
	$"CCCC 0000 0000 0000 9999 0000 0000 0000"            /* ��......��...... */
	$"6666 0000 0000 0000 3333 0000 EEEE 0000"            /* ff......33..��.. */
	$"0000 0000 DDDD 0000 0000 0000 BBBB 0000"            /* ....��......��.. */
	$"0000 0000 AAAA 0000 0000 0000 8888 0000"            /* ....��......��.. */
	$"0000 0000 7777 0000 0000 0000 5555 0000"            /* ....ww......UU.. */
	$"0000 0000 4444 0000 0000 0000 2222 0000"            /* ....DD......"".. */
	$"0000 0000 1111 0000 0000 0000 0000 EEEE"            /* ..............�� */
	$"0000 0000 0000 DDDD 0000 0000 0000 BBBB"            /* ......��......�� */
	$"0000 0000 0000 AAAA 0000 0000 0000 8888"            /* ......��......�� */
	$"0000 0000 0000 7777 0000 0000 0000 5555"            /* ......ww......UU */
	$"0000 0000 0000 4444 0000 0000 0000 2222"            /* ......DD......"" */
	$"0000 0000 0000 1111 0000 0000 0000 0000"            /* ................ */
	$"EEEE 0000 0000 0000 DDDD 0000 0000 0000"            /* ��......��...... */
	$"BBBB 0000 0000 0000 AAAA 0000 0000 0000"            /* ��......��...... */
	$"8888 0000 0000 0000 7777 0000 0000 0000"            /* ��......ww...... */
	$"5555 0000 0000 0000 4444 0000 0000 0000"            /* UU......DD...... */
	$"2222 0000 0000 0000 1111 0000 EEEE EEEE"            /* ""..........���� */
	$"EEEE 0000 DDDD DDDD DDDD 0000 BBBB BBBB"            /* ��..������..���� */
	$"BBBB 0000 AAAA AAAA AAAA 0000 8888 8888"            /* ��..������..���� */
	$"8888 0000 7777 7777 7777 0000 5555 5555"            /* ��..wwwwww..UUUU */
	$"5555 0000 4444 4444 4444 0000 2222 2222"            /* UU..DDDDDD.."""" */
	$"2222 0000 1111 1111 1111 0000 0000 0000"            /* "".............. */
	$"0000 0000 0000 0064 0174 0000 0000 0064"            /* .......d.t.....d */
	$"0174 0000 0006 810A 810A 8D0A 0026 E10A"            /* .t....��.&�� */
	$"02FF ACFF D90A FC22 F80A 0122 22DF 0A05"            /* .������"��.""��. */
	$"2222 0A0A 2222 F10A 0122 22F2 0A01 2222"            /* ""��""��.""��."" */
	$"810A B30A 0029 E20A 0481 ACFE FFFF DA0A"            /* �³�.)��.������� */
	$"0122 22F5 0A01 2222 DF0A 0522 220A 0A22"            /* .""��.""��.""��" */
	$"22F1 0A01 2222 F20A 0122 2281 0AB3 0A00"            /* "��.""��.""�³�. */
	$"5EE5 0A08 F9F9 ACAC FDFF ACFF 2BDB 0A01"            /* ^��.��������+��. */
	$"2222 FD0A 0622 220A 0A22 220A FD22 000A"            /* ""��.""��""��".� */
	$"FC22 010A 0AFE 2201 0A0A FA22 FE0A FE22"            /* �".���".���"���" */
	$"FB0A FD22 000A FD22 FE0A FE22 010A 0AFD"            /* ���".��"���".��� */
	$"2208 0A0A 2222 0A22 220A 0AFD 22FC 0AFD"            /* ".��""�""���"��� */
	$"2201 0A0A FE22 FD0A 0122 2281 0ABF 0A00"            /* ".���"��.""�¿�. */
	$"64E5 0A09 FFFE FDFF FAFF FBFF F8FF DC0A"            /* d��������������� */
	$"FD22 FE0A FD22 FE0A 0322 220A 0AFE 22FE"            /* �"���"��.""���"� */
	$"0A13 2222 0A22 220A 2222 0A22 220A 2222"            /* �.""�""�""�""�"" */
	$"0A22 220A 2222 FB0A 0822 220A 0A22 220A"            /* �""�""��.""��""� */
	$"2222 FD0A 0822 220A 2222 0A22 220A FD22"            /* ""��.""�""�""��" */
	$"030A 0A22 22F8 0A08 2222 0A0A 2222 0A22"            /* .��""��.""��""�" */
	$"2281 0ABA 0A00 64E6 0A0E FDFD FFFE 56FE"            /* "�º�.d��.����V� */
	$"F9F9 FA56 F8F7 FFFF 81E0 0A01 2222 FB0A"            /* ���V�������.""�� */
	$"0122 22FD 0A05 2222 0A0A 2222 FD0A FC22"            /* .""��.""��""���" */
	$"090A 2222 0A22 220A 2222 0AFC 22FB 0A0A"            /* ��""�""�""��"��� */
	$"2222 0A0A 2222 0A22 220A 0AFD 2206 0A22"            /* ""��""�""���".�" */
	$"220A 2222 0AFE 22FD 0AFE 22FA 0A08 2222"            /* "�""��"���"��."" */
	$"0A0A 2222 0A22 2281 0ABA 0A00 67E7 0A08"            /* ��""�""�º�.g��. */
	$"FFFF FEFB FBFF ACF9 F8FE F902 56F9 F8DF"            /* �����������.V��� */
	$"0A01 2222 FC0A FD22 FE0A 0522 220A 0A22"            /* �.""���"��.""��" */
	$"22FD 0A01 2222 FD0A 0A22 220A 2222 0A22"            /* "��.""���""�""�" */
	$"220A 2222 F80A 1522 220A 0A22 220A 2222"            /* "�""��.""��""�"" */
	$"0A22 220A 2222 0A22 220A 2222 0AFD 22FC"            /* �""�""�""�""��"� */
	$"0A01 2222 FB0A 0822 220A 0A22 220A 2222"            /* �.""��.""��""�"" */
	$"810A BA0A 006C E80A 10FD FFFF ACFC FFFD"            /* �º�.l��.������� */
	$"F956 F9F7 FAF9 F9FF 56FF E00A FC22 060A"            /* �V������V����".� */
	$"2222 0A0A 2222 FE0A 0422 220A 2222 FC0A"            /* ""��""��.""�""�� */
	$"FE22 0B0A 0A22 220A 2222 0A22 220A 0AFE"            /* �".��""�""�""��� */
	$"22F9 0A09 2222 0A22 220A 2222 0A0A FD22"            /* "���""�""�""���" */
	$"0C0A 2222 0A22 220A 2222 0A22 220A FD22"            /* .�""�""�""�""��" */
	$"F90A 0322 220A 0AFE 22FD 0A01 2222 810A"            /* ��.""���"��.""�� */
	$"BF0A 001B E90A 00FE FEFF 02FC FFFF FEF9"            /* ��..��.���.����� */
	$"0756 F956 56F8 ACFF FF81 0A81 0AB7 0A00"            /* .V�VV�����·�. */
	$"1EEA 0A12 FDFE FFFF FDFE FFFE F9F9 81F9"            /* .��.������������ */
	$"F8FA FAF7 F8FF FF81 0AB7 0AFE 2284 0A00"            /* ��������·��"��. */
	$"73EA 0A00 FEFE FF0F FCFF FFFE F9FA F9F9"            /* s��.���.�������� */
	$"FAFB FFFC F9FC FFFF C70A FC22 F30A FE22"            /* �����������"���" */
	$"FC0A FC22 030A 0A22 22EA 0AFD 22FE 0A01"            /* ���".��""���"��. */
	$"2222 E70A FD22 F90A FE22 000A FE22 030A"            /* ""���"���".��".� */
	$"0A22 22E8 0A04 2222 0A22 22FA 0A01 2222"            /* �""��.""�""��."" */
	$"FD0A 0122 22F1 0A01 2222 FC0A 0522 220A"            /* ��.""��.""��.""� */
	$"0A22 22F3 0A01 2222 EC0A 0122 22F8 0A01"            /* �""��.""��.""��. */
	$"2222 E30A 0076 EA0A FDFF 0FFC FEFF ACF9"            /* ""��.v����.����� */
	$"FAF9 FAFB FBFF FFFA FFFE FFC7 0A05 2222"            /* �������������."" */
	$"0A0A 2222 F30A 0122 22FC 0A01 2222 E40A"            /* ��""��.""��.""�� */
	$"0922 220A 0A22 220A 0A22 22E8 0A05 2222"            /* �""��""��""��."" */
	$"0A0A 2222 F90A 0522 220A 0A22 22E4 0AFD"            /* ��""��.""��""��� */
	$"220F 0A0A 040A 040A 040A 2222 040A 040A"            /* ".��.�.�.�"".�.� */
	$"2222 F10A 0122 22FC 0A05 2222 0A0A 2222"            /* ""��.""��.""��"" */
	$"F30A 0122 22EC 0A01 2222 D80A 00E0 EB0A"            /* ��.""��.""��.��� */
	$"14FD FEFF FFAC FBAC FFFC AC56 F9FA FAFB"            /* .����������V���� */
	$"FFFF ACFB FFFF C70A 0722 220A 0A22 220A"            /* ��������.""��""� */
	$"0AFE 220A 0A0A 2222 0A22 220A 0A22 22FC"            /* ��"���""�""��""� */
	$"0A01 2222 FD0A FE22 000A FD22 010A 0AFD"            /* �.""���".��".��� */
	$"22F6 0A01 2222 FC0A FD22 010A 0AFE 2209"            /* "��.""���".���"� */
	$"0A0A 2222 0A0A 2222 0A0A FE22 FB0A 0122"            /* ��""��""���"��." */
	$"22FC 0A0D 2222 0A22 220A 0A22 220A 0A22"            /* "��.""�""��""��" */
	$"220A FE22 080A 2222 0A0A 2222 0A0A FE22"            /* "��".�""��""���" */
	$"010A 0AFD 22F9 0A0B 2222 040A 040A 040A"            /* .���"��."".�.�.� */
	$"040A 040A FB22 0204 0A0A FE22 010A 0AFC"            /* .�.��"..���".��� */
	$"2201 0A0A FD22 FC0A 0722 220A 0A22 220A"            /* ".���"��.""��""� */
	$"0AFE 2201 0A0A FC22 000A FD22 010A 0AFE"            /* ��".���".��".��� */
	$"2201 0A0A FD22 FE0A FD22 000A FD22 010A"            /* ".���"���".��".� */
	$"0AFE 2201 0A0A FE22 000A FD22 E80A 00E0"            /* ��".���".��"��.� */
	$"EB0A 14AC FBFF FFFA FFFD FC56 ACFF FDF9"            /* ��.��������V���� */
	$"FBAC FFFF FEF9 FFFF C70A FC22 FC0A 0B22"            /* �����������"��." */
	$"220A 2222 0A22 220A 0A22 22FC 0AFD 22FE"            /* "�""�""��""���"� */
	$"0A0D 2222 0A22 220A 2222 0A22 220A 2222"            /* �.""�""�""�""�"" */
	$"F60A FD22 FE0A 0A22 220A 0A22 220A 2222"            /* ���"���""��""�"" */
	$"0A0A FD22 060A 0A22 220A 2222 FB0A FD22"            /* ���".��""�""���" */
	$"140A 0A22 220A 2222 0A0A 2222 0A0A 2222"            /* .��""�""��""��"" */
	$"0A0A 2222 0A0A FD22 FC0A 0722 220A 2222"            /* ��""���"��.""�"" */
	$"0A22 22FD 0A01 040A FB22 0604 0A04 0A04"            /* �""��..��"..�.�. */
	$"0A04 FB22 070A 040A 040A 2222 0AFE 22FE"            /* �.�".�.�.�""��"� */
	$"0A04 2222 0A22 22FC 0AFB 22FD 0A02 2222"            /* �.""�""���"��."" */
	$"0AFE 22FD 0A11 2222 0A0A 2222 0A22 220A"            /* ��"��.""��""�""� */
	$"2222 0A22 220A 2222 FC0A 1222 220A 0A22"            /* ""�""�""��.""��" */
	$"220A 2222 0A0A 2222 0A22 220A 2222 E90A"            /* "�""��""�""�""�� */
	$"00E3 EC0A 14FF AC0A ACFA F8FE FEFF F981"            /* .���.��¬������� */
	$"FFFE 56FC FEFF FDFD FFFF C60A 0122 22FB"            /* ��V���������.""� */
	$"0AFD 2209 0A22 220A 2222 0A0A 2222 FC0A"            /* ��"��""�""��""�� */
	$"0122 22FC 0A0D 2222 0A22 220A 2222 0A22"            /* .""��.""�""�""�" */
	$"220A 2222 F30A 0722 220A 0A22 220A 0AFC"            /* "�""��.""��""��� */
	$"2201 0A0A FD22 010A 0AFC 22F8 0A15 2222"            /* ".���".���"��."" */
	$"0A22 220A 2222 0A0A 2222 0A0A 2222 0A0A"            /* �""�""��""��""�� */
	$"2222 0A0A FD22 FE0A FD22 050A 2222 0A22"            /* ""���"���".�""�" */
	$"22FE 0A10 040A 2222 040A 2222 040A 040A"            /* "��..�"".�"".�.� */
	$"040A 040A 04FD 2203 0A04 0A04 FD22 020A"            /* .�.�.�".�.�.�".� */
	$"2222 FD0A 0422 220A 2222 FC0A 0722 220A"            /* ""��.""�""��.""� */
	$"0A22 220A 0AFD 2202 0A22 22FC 0A03 2222"            /* �""���".�""��."" */
	$"0A0A FC22 070A 2222 0A22 220A 0AFE 22FE"            /* ���".�""�""���"� */
	$"0A03 2222 0A0A FC22 090A 0A22 220A 2222"            /* �.""���"���""�"" */
	$"0A22 22E9 0A00 F5ED 0A15 FFFC 0AFA FFFA"            /* �""��.���.������ */
	$"FDFE FFAC F9FF FFFE FEFF FAFB FCFD FDFF"            /* ���������������� */
	$"C60A 0122 22FC 0A0E 2222 0A22 220A 2222"            /* ��.""��.""�""�"" */
	$"0A22 220A 0A22 22FC 0A01 2222 FC0A 0D22"            /* �""��""��.""��." */
	$"220A 2222 0A22 220A 2222 0A22 22F7 0A0D"            /* "�""�""�""�""��. */
	$"2222 0A0A 2222 0A0A 2222 0A0A 2222 FB0A"            /* ""��""��""��""�� */
	$"0122 22FE 0A01 2222 F90A 1722 220A 0A22"            /* .""��.""��.""��" */
	$"220A 2222 0A22 220A 0A22 220A 0A22 220A"            /* "�""�""��""��""� */
	$"0A22 22FE 0A01 2222 FE0A 1222 220A 2222"            /* �""��.""��.""�"" */
	$"0A22 220A 2222 040A 040A 0422 220A FD22"            /* �""�"".�.�.""��" */
	$"0704 0A04 0A04 0A04 0AFD 220A 040A 0422"            /* ..�.�.�.��"�.�." */
	$"220A 2222 0422 22FD 0A04 2222 0A22 22FC"            /* "�"".""��.""�""� */
	$"0A0E 2222 0A0A 2222 0A22 220A 2222 0A22"            /* �.""��""�""�""�" */
	$"22FC 0A05 2222 0A0A 2222 FD0A 0422 220A"            /* "��.""��""��.""� */
	$"2222 FD0A 0922 220A 0A22 220A 0A22 22FC"            /* ""���""��""��""� */
	$"0A07 2222 0A22 220A 2222 E90A 00E1 EB0A"            /* �.""�""�""��.��� */
	$"13FB FFFE F72B 81F7 F8FA FDFC F8FF FDFA"            /* .����+���������� */
	$"FFFF FDFF FFC6 0A01 2222 FB0A FD22 010A"            /* �������.""���".� */
	$"0AFD 2203 0A0A 2222 FC0A 0122 22FC 0A0D"            /* ��".��""��.""��. */
	$"2222 0A22 220A 2222 0A22 220A 2222 FE0A"            /* ""�""�""�""�""�� */
	$"0122 22FB 0AFD 22FD 0A03 2222 0A0A FE22"            /* .""���"��.""���" */
	$"FD0A 0122 22FD 0AFE 22FA 0AFD 22FE 0AFD"            /* ��.""���"���"��� */
	$"220B 0A0A 2222 0A0A 2222 0A0A 2222 FE0A"            /* ".��""��""��""�� */
	$"0122 22FD 0AFD 220B 0A22 220A 2222 0A04"            /* .""���".�""�""�. */
	$"0A04 0A04 FE22 0A04 0A22 2204 0A04 0A04"            /* �.�.�"�.�"".�.�. */
	$"0A04 FD22 030A 040A 04FD 2203 0A22 2204"            /* �.�".�.�.�".�"". */
	$"FD0A FD22 FC0A 0722 220A 0A22 220A 0AFD"            /* ���"��.""��""��� */
	$"2202 0A22 22FB 0A03 2222 0A0A FE22 070A"            /* ".�""��.""���".� */
	$"0A22 220A 2222 0AFD 22FD 0A03 2222 0A0A"            /* �""�""��"��.""�� */
	$"FE22 FE0A 0722 220A 2222 0A22 22E9 0A00"            /* �"��.""�""�""��. */
	$"48EB 0A0D FF0A FDF7 FE56 F7F7 5656 ACF8"            /* H��.�����V��VV�� */
	$"F8F9 FDFF 02F9 00FF 940A 0122 22B0 0A26"            /* ����.�.���.""��& */
	$"040A 040A 040A 040A 040A 040A 040A 040A"            /* .�.�.�.�.�.�.�.� */
	$"040A 040A 040A 040A 040A 040A 040A 040A"            /* .�.�.�.�.�.�.�.� */
	$"040A 040A 040A 049F 0A00 2CFB 5FFD 0A04"            /* .�.�.�.��.,�_��. */
	$"ACFF FEFE FFF8 0A13 FD56 FCF9 5656 FAF9"            /* �������.�V��VV�� */
	$"F7F8 F7F7 FE81 81AC FAF5 00FF FE0A 995F"            /* ����������.��_ */
	$"0122 2281 5FA6 5F00 31FC 5FFD 0A06 FFFA"            /* .""�_�_.1�_��.�� */
	$"FA81 F8F9 FFFE FD19 FFFF FE0A 0AFF 56FB"            /* �������.������V� */
	$"F9F9 F8F9 FBF9 F7F7 F8F8 F7F8 FDF7 F5FC"            /* ���������������� */
	$"FFFF FE0A 815F 815F BD5F 0034 FD5F FE0A"            /* ���_�_�_.4�_�� */
	$"11FE 56FF F9F8 81FD F7FE FFAC FC81 56F7"            /* .�V�����������V� */
	$"FAFB 81FE 5611 F756 FDAC 56F8 F8F7 F981"            /* ����V.�V��V����� */
	$"FCF9 F6F9 FCF6 2BFF FE0A 815F 815F BE5F"            /* ������+��_�_�_ */
	$"005A FA0A 27FC FFF9 F9F8 F756 81FF FCFA"            /* .Z��'������V���� */
	$"FBFA F8F7 ACF8 FDFF F956 56F8 F856 56F8"            /* ���������VV��VV� */
	$"F82B ACFD 56F5 F5FD F7F5 F52B F5FC 0AC0"            /* �+��V������+���� */
	$"10E0 0AEE 10B0 0A0D 040A 040A 040A 040A"            /* .���.��..�.�.�.� */
	$"040A 040A 040A EB02 0C04 0A04 0A04 0A04"            /* .�.�.��...�.�.�. */
	$"0A04 0A04 0A04 D70A F710 EC0A 0056 FA0A"            /* �.�.�.���.��.V�� */
	$"29FC FFF9 56F8 F8FD FA81 FAFF F9FC F9F8"            /* )���V����������� */
	$"F7F7 81F8 FDF8 FAF9 F856 56F8 F7F9 FD2B"            /* ���������VV����+ */
	$"F600 FCFB F5F9 F9F6 56F5 FFBC 10E1 0AE2"            /* �.������V���.��� */
	$"10BB 0A0A 040A 040A 040A 040A 040A 04E7"            /* .���.�.�.�.�.�.� */
	$"020B 0A04 0A04 0A04 0A04 0A04 0A04 DA0A"            /* ..�.�.�.�.�.�.�� */
	$"F410 ED0A 0058 F90A 25FE FBF8 5656 81F9"            /* �.��.X��%���VV�� */
	$"F9FD AC81 FE81 F9F8 F7F7 F8FA FEAC FEFC"            /* ���������������� */
	$"FAF9 F7FA FEF7 F62B 81FE F8FB FBF7 2BFE"            /* �������+������+� */
	$"F6BA 10E4 0ADF 10BE 0A09 040A 040A 040A"            /* ��.���.���.�.�.� */
	$"040A 040A F702 F701 F702 0A04 0A04 0A04"            /* .�.��.�.�.�.�.�. */
	$"0A04 0A04 0A04 DB0A F310 EF0A 0010 005E"            /* �.�.�.���.��...^ */
	$"0010 FA0A 0EFB FD56 F8F9 FCAC FB81 81AC"            /* ..��.��V�������� */
	$"FCFB AC81 FDF8 FEF7 0CF9 FFFC FEFF FEFC"            /* ��������.������� */
	$"F8AC FDFC FCF8 FEF6 03FA ACF7 FFB8 10E9"            /* ��������.�����.� */
	$"0ADC 10D8 0AF5 10F5 0A09 040A 040A 040A"            /* ��.���.���.�.�.� */
	$"040A 040A F902 F101 F902 0A04 0A04 0A04"            /* .�.��.�.�.�.�.�. */
	$"0A04 0A04 0A04 DD0A F010 F30A FE10 0059"            /* �.�.�.���.���..Y */
	$"F810 0DFF FFFE FCFB F9FB FDFF F9FA F9F8"            /* �..������������� */
	$"FCFC 5615 F8F7 F8FF F9F7 5656 FCFB FDFC"            /* ��V.������VV���� */
	$"2BF9 FEAC FFAC F6F7 F62B 8110 F910 DC0A"            /* +��������+�.�.�� */
	$"F210 F70A 0904 0A04 0A04 0A04 0A04 0AFA"            /* �.���.�.�.�.�.�� */
	$"02ED 01FA 020A 040A 040A 040A 040A 040A"            /* .�.�.�.�.�.�.�.� */
	$"04E0 0AEC 10F7 0AFC 1000 61F9 102A FCFD"            /* .���.���..a�.*�� */
	$"F981 FD81 FBFC 81FD F9FC FFF7 FDF9 F9FA"            /* ���������������� */
	$"F9F8 F8F9 FCF9 F7F8 F7F7 F8F9 81FB F900"            /* ���������������. */
	$"F8FA F52B F72B 2BFF 5681 10C5 10F9 0A09"            /* ���+�++�V�.�.��� */
	$"040A 040A 040A 040A 040A FB02 E901 FB02"            /* .�.�.�.�.��.�.�. */
	$"0A04 0A04 0A04 0A04 0A04 0A04 F60A 0234"            /* �.�.�.�.�.�.��.4 */
	$"5F5F FE89 0265 5F34 F60A DC10 005C F910"            /* __��.e_4���..\�. */
	$"00FF FEF8 0AFB AC56 56FA FBF9 81F9 56FE"            /* .������VV�����V� */
	$"FEF9 FE56 15FC FE56 F7F8 F8F7 F856 F7FB"            /* ���V.��V�����V�� */
	$"FBF7 0081 81F5 F62B F6F9 FF81 10C3 10FC"            /* ��.����+����.�.� */
	$"0A09 040A 040A 040A 040A 040A FB02 E701"            /* ��.�.�.�.�.��.�. */
	$"FB02 0804 0A04 0A04 0A04 0A04 FA0A FE10"            /* �...�.�.�.�.���. */
	$"003A F789 005F F80A DB10 0052 FA10 0CAC"            /* .:��._���..R�..� */
	$"FAF8 F8F9 F8FA F9F8 F9FC FEF9 FEAC 1BFA"            /* ��������������.� */
	$"FAFB FCFB F881 FDF9 F956 F8F7 F8F7 F7F6"            /* ���������V������ */
	$"FDFC F600 2BF6 F62B F600 FD81 10C2 10FE"            /* ���.+��+�.��.�.� */
	$"0A09 040A 040A 040A 040A 040A FC02 E301"            /* ��.�.�.�.�.��.�. */
	$"FC02 F70A FA10 005F F489 FB0A D910 0057"            /* �.���.._����..W */
	$"FA10 1BAC AC56 F9F9 AC81 F9F8 F9AC FCFB"            /* �..��V���������� */
	$"81FD FDFA FBAC AC81 81FB FFFF 8156 F8FE"            /* �������������V�� */
	$"F70C 2BF7 F7FF F7F5 F5F6 F6F5 F52B FF81"            /* �.+����������+�� */
	$"10C0 1009 0A0A 040A 040A 040A 040A FC02"            /* .�.���.�.�.�.��. */
	$"E101 FC02 F80A FB10 005F FE89 003A FD10"            /* �.�.���.._��.:�. */
	$"013A 5FFC 89D4 1000 49FA 1001 FEFF FEF9"            /* .:_���..I�..���� */
	$"12AC FEAC F9FC FA56 F9F9 FCFC 81FD ACFC"            /* .������V�������� */
	$"F8FF F7F9 FCFF 0EFE FDFD FCFA FFFC 2BF5"            /* ������.�������+� */
	$"F5F6 F6F5 56FF 8110 C010 F80A FC02 DF01"            /* ����V��.�.���.�. */
	$"FC02 F80A FC10 FD89 0065 FA10 FD89 003A"            /* �.���.��.e�.��.: */
	$"D510 0052 F910 19FF FCFA 81AC ACFA FDFB"            /* �..R�..��������� */
	$"FA56 FBFA F9FC 81FC FB56 FAFF F8FB ACFC"            /* �V�������V������ */
	$"81FE F90D FAFA FDAC ACFF FB2B F5F5 F6F7"            /* ���.�������+���� */
	$"81FF CF10 0016 8110 F310 F80A FC02 DF01"            /* ���...�.�.���.�. */
	$"FC02 F80A FD10 063A 893A 103A 8989 FA10"            /* �.���..:�:.:���. */
	$"FE89 003A D510 005F F910 05FE FFFB 81FB"            /* ��.:�.._�..����� */
	$"FBFE AC0B 56FA FA56 FAFA ACFA FCFB FEF9"            /* ���.V��V�������� */
	$"FE56 11F9 F956 F7F8 56F8 FCFD FCFC FE81"            /* �V.��V��V������� */
	$"F7F6 F656 FFD5 1000 16FD 10FC 16C8 1001"            /* ���V��...�.�.�.. */
	$"3A3A FC5F 013A 3AB8 10F8 0AFC 02DD 01FC"            /* ::�_.::�.���.�.� */
	$"02F8 0AFE 1001 5F89 FE10 023A 895F FB10"            /* .���.._��..:�_�. */
	$"035F 8989 3AD5 1000 6BF8 1007 FEFF ACAC"            /* ._��:�..k�..���� */
	$"FFFE FCF9 FEFA 0AF9 FCFA FCFC 56F9 F9F8"            /* ������������V��� */
	$"F7F8 FD56 0EF7 F856 FBFB FDFB F9FB FFFB"            /* ���V.��V�������� */
	$"FAFA FFAC D610 F616 CB10 005F F489 015F"            /* �����.�.�.._�._ */
	$"3AF9 1000 3AFE 5FFD 8900 5FDE 1001 8989"            /* :�..:�_��._�..�� */
	$"FE5F 0289 895F F810 F80A FD02 DB01 FD02"            /* �_.��_�.���.�.�. */
	$"F80A FE10 015F 5FFD 1001 5F89 FA10 0289"            /* ���..__�.._��..� */
	$"893A D510 005B F710 1481 ACFC FFF9 FAFA"            /* �:�..[�..������� */
	$"8181 FAFB FDFB FBFC FEF9 2BF8 F8F7 FEF8"            /* ����������+����� */
	$"0EF7 F7F8 F9FE F9AC FA81 FAFA FBFF FFFD"            /* .��������������� */
	$"D510 F516 CE10 005F EF89 FA10 F889 DE10"            /* �.�.�.._��.���. */
	$"F989 003A F910 F90A FC02 DB01 FC02 F90A"            /* ��.:�.���.�.�.�� */
	$"FE10 015F 65FC 1001 8989 FB10 0189 89D4"            /* �.._e�..���..��� */
	$"1000 72F4 1011 FEFB FAF9 FBFD ACAC FAAC"            /* ..r�..���������� */
	$"81FB FDFF F9F8 F856 FDF8 0DF7 2BAC FBFE"            /* �������V��.�+��� */
	$"F956 FAF9 F9FA F9FD FEDF 1000 16F9 10F2"            /* �V��������...�.� */
	$"16D2 1000 3AFD 8901 653A FB10 013A 5FFA"            /* .�..:��.e:�..:_� */
	$"89FB 1600 5FF9 89F7 1000 3AFE 5FEB 1000"            /* ��.._���..:�_�.. */
	$"65FB 8900 3AFA 10F8 0AFD 02D9 01FD 02F8"            /* e��.:�.���.�.�.� */
	$"0A03 1010 3A89 FC10 023A 895F FD10 035F"            /* �...:��..:�_�.._ */
	$"8989 3AD5 1000 78F4 100E FBFE 81FA FCFC"            /* ��:�..x�..������ */
	$"FBAC FEAC 81FE FAFB FAFE 5600 F8FE F70E"            /* ����������V.���. */
	$"2BFB FF56 AC56 56F9 56F9 FAFA F9FF FDEC"            /* +��V�VV�V������� */
	$"1001 1616 F910 FC16 FD10 EC16 D710 005F"            /* ....�.�.�.�.�.._ */
	$"FE89 005F F710 0116 5FFB 89FA 1600 3AFA"            /* ��._�..._���..:� */
	$"89FE 16FB 10FB 8900 3AEC 10FB 8900 3AFA"            /* ��.�.��.:�.��.:� */
	$"10F9 0AFC 02D9 01FC 02F9 0AFE 1001 8965"            /* .���.�.�.���..�e */
	$"FC10 0565 8989 5F3A 5FFE 8900 3AD5 1000"            /* �..e��_:_��.:�.. */
	$"6FF3 100C FBFF FBFB FEFF FFFB 562B F9F9"            /* o�..��������V+�� */
	$"FFFE F913 56F8 F8F7 F7AC FFFB FA81 5681"            /* ���.V���������V� */
	$"F9F9 FBF9 F9FB FCFF F210 D316 D810 0065"            /* ���������.�.�..e */
	$"FE89 003A FB10 FB16 003A FC89 005F F916"            /* ��.:�.�..:��._�. */
	$"003A FB89 FD16 FD10 005F FA89 EC10 005F"            /* .:���.�.._���.._ */
	$"FC89 003A FA10 F90A FD02 D701 FD02 F90A"            /* ��.:�.���.�.�.�� */
	$"FE10 025F 8989 FC10 003A FA89 003A D510"            /* �.._���..:��.:�. */
	$"0066 F110 17FE FFAC FEFF F8F8 FAF9 FFAC"            /* .f�..����������� */
	$"ACF9 FAF9 F8F7 56FB FA81 FFF9 F8FD 5605"            /* ������V�������V. */
	$"F856 F9F9 FBFF F410 D016 DA10 005F FE89"            /* �V�����.�.�.._�� */
	$"003A F416 FC89 0065 F716 FB89 FC16 FE10"            /* .:�.��.e�.���.�. */
	$"005F FA89 EC10 005F FC89 003A FA10 F90A"            /* ._���.._��.:�.�� */
	$"FD02 D701 FD02 F90A FD10 0465 8989 655F"            /* �.�.�.���..e��e_ */
	$"FE3A 005F FB89 D410 0070 F010 0A16 FDFC"            /* �:._���..p�.�.�� */
	$"ACFD F7F8 FA81 FAFF FDF9 11FC FAAC FD81"            /* ����������.����� */
	$"FBF8 F781 F7F8 56F9 F9FA F9FE FFFA 10FD"            /* ������V�������.� */
	$"1602 F9FD FFD1 16E6 10F6 1600 3AFE 8900"            /* ..����.�.�..:��. */
	$"3AF4 16FC 8900 5FF6 16FB 89FA 1601 1010"            /* :�.��._�.���.... */
	$"FB89 003A EC10 005F FC89 003A FB10 F80A"            /* ��.:�.._��.:�.�� */
	$"FD02 D701 FD02 F80A FD10 005F F589 003A"            /* �.�.�.���.._��.: */
	$"FA10 0016 F910 0016 E510 006F F210 FD16"            /* �...�...�..o�.�. */
	$"1D81 81F9 FBF8 2BF7 FDFB FD81 FFFA FCFA"            /* .�����+��������� */
	$"ACF9 FBF9 56F7 FFF9 56F9 81F9 F9FD FEF5"            /* ����V���V������� */
	$"1603 ACFE F9FF D116 E910 F416 FE89 0065"            /* ..�����.�.�.��.e */
	$"F516 003A FD89 0065 F416 FB89 F716 033A"            /* �..:��.e�.���..: */
	$"6565 5FEA 1000 5FFC 8900 3AFB 10F9 0AFD"            /* ee_�.._��.:�.��� */
	$"02D5 01FD 02F9 0AFB 1000 65F8 8902 3A16"            /* .�.�.���..e��.:. */
	$"16FD 10FC 16FD 10FC 16E7 1000 64F7 10F8"            /* .�.�.�.�.�..d�.� */
	$"161C FBFB F681 FF81 F756 FEF8 FAFA FCF9"            /* ..�������V������ */
	$"81F9 F9FA F9F9 56F9 F8F9 56FA F9FB FFF6"            /* ������V���V����� */
	$"1606 F9AC FDF8 F7FA FFD0 16F0 10F0 1600"            /* ..��������.�.�.. */
	$"65FE 89F6 1600 3AFD 8900 65F2 16FB 89DC"            /* e���..:��.e�.��� */
	$"1600 65FC 8900 3AFB 16F9 10FD 02D5 01FD"            /* ..e��.:�.�.�.�.� */
	$"02F9 0AFA 1001 163A FD65 015F 3AE0 16F2"            /* .���...:�e._:�.� */
	$"1000 51EE 160D ACF9 F556 F6FD FF81 FB81"            /* ..Q�..���V������ */
	$"ACF9 56FB FBF9 0256 F856 FEF9 01AC FFF5"            /* ��V���.V�V��.��� */
	$"1607 FDFD 56F7 F8F8 81FC AF16 FE89 0065"            /* ..��V������.��.e */
	$"F716 0065 FE89 0065 F016 FB89 DC16 0065"            /* �..e��.e�.���..e */
	$"FC89 003A FB16 F910 FD02 D501 FD02 F90A"            /* ��.:�.�.�.�.�.�� */
	$"FE10 C516 0060 EE16 1AAC F9F6 F5F6 FEAC"            /* �.�..`�..������� */
	$"ACFE FDFB ACFC FFF9 FAFA 5656 F856 F8F9"            /* ����������VV�V�� */
	$"FAAC FFFF F416 07FF FB2B F8F8 56F8 FDB0"            /* �����..��+��V��� */
	$"1600 65FE 8900 3AF9 1600 3AFE 8900 65EE"            /* ..e��.:�..:��.e� */
	$"16FB 89DC 1600 65FC 8900 3AFB 16F9 10FD"            /* .���..e��.:�.�.� */
	$"02F4 0100 08FA 0100 08EB 01FD 02F9 10F0"            /* .�...�...�.�.�.� */
	$"1601 653A D516 008C EE16 12FC 56F6 F5F5"            /* ..e:�..��..�V��� */
	$"FCFB FEFB FAFA F9FC FCF8 F856 F8F8 FE56"            /* �����������V���V */
	$"FDFF FE16 0456 16F9 FDFE FDFF 05FE FFFF"            /* ���..V.�����.��� */
	$"FEFA 2BFE F801 81FF B116 FD89 F916 0365"            /* ��+��.���.���..e */
	$"8989 5FEC 16FB 89FB 1600 3AFE 8907 653A"            /* ��_�.���..:��.e: */
	$"3A5F 6589 8965 F716 0065 FE89 0165 3AFE"            /* :_e��e�..e��.e:� */
	$"1600 65FC 8900 3AFB 16FC 1001 3A5F F789"            /* ..e��.:�.�..:_�� */
	$"015E 33FD 0100 2CFD 89FE 5EFD 8907 0101"            /* .^3�..,���^��... */
	$"5782 8989 5E33 F401 FD02 F910 F116 0265"            /* W���^3�.�.�.�..e */
	$"893A D516 0082 EE16 1CFE 56F5 00F6 FAFF"            /* �:�..��..�V�.��� */
	$"FBFA 81FC ACFF FDF9 FBFF FEF9 56FA FDAC"            /* ������������V��� */
	$"FDFE 1616 81FA FEFF 11AC FCFC FBFA F9FB"            /* ��..����.������� */
	$"FEFD FEFE 56F8 F8F7 F7FB FEB3 1600 3AFD"            /* ����V�������..:� */
	$"89FB 1603 3A89 8965 EA16 FB89 FB16 0065"            /* ��..:��e�.���..e */
	$"F689 F916 0065 F989 0265 1665 FC89 003A"            /* ���..e��.e.e��.: */
	$"FB16 FD10 005F F389 0033 FD01 012C 5EFA"            /* �.�.._�.3�..,^� */
	$"8902 5E01 08FA 8900 82F5 01FD 02F9 10F5"            /* �.^..��.��.�.�.� */
	$"1601 3A65 FD89 D416 008E EE16 08FD F8F7"            /* ..:e���..��..��� */
	$"F7F6 F9FF FBAC FEFE 05F9 FAFD FB56 FEFE"            /* ��������.����V�� */
	$"FF1C FB81 ACFE 16FE FCFB F956 FAF9 FAAC"            /* �.����.����V���� */
	$"FBFC 8181 56FF 16FD FEF9 F8F7 F7FA FDB3"            /* ����V�.��������� */
	$"1600 3AFD 89FC 1603 6589 893A E916 FB89"            /* ..:���..e��:�.�� */
	$"FA16 0065 F889 003A FA16 FC89 033A 163A"            /* �..e��.:�.��.:.: */
	$"5FF8 8900 3AFB 16FE 10FB 8903 5E33 3357"            /* _��.:�.�.��.^33W */
	$"FB89 005E FB01 005E FC89 0282 012C F889"            /* ��.^�..^��.�.,�� */
	$"0082 F601 FD02 F910 0216 1665 FE89 003A"            /* .��.�.�....e��.: */
	$"FE16 0065 FA89 D416 0091 EE16 0AFF F8F8"            /* �..e���..��.���� */
	$"F9F5 F5FC ACFD F8F5 FDF6 13F5 F62B F8FC"            /* ����������.��+�� */
	$"F856 F9FC FFFD AC56 F9FA FDFE FFFD ACFE"            /* �V�����V�������� */
	$"F90C FA56 ACFD 16FF FEFA F781 F9FD ACB4"            /* �.�V��.��������� */
	$"1600 65FD 89FD 1603 3A89 893A E816 FB89"            /* ..e���..:��:�.�� */
	$"F916 005F FB89 0065 F916 FD89 0065 FB16"            /* �.._��.e�.��.e�. */
	$"0065 FA89 003A FB16 0110 10FC 8900 5FFD"            /* .e��.:�....��._� */
	$"0202 0101 82FD 8900 5EFB 0100 33FC 8901"            /* ....���.^�..3��. */
	$"5E2C F689 002C F701 FD02 F910 0116 3AFC"            /* ^,��.,�.�.�...:� */
	$"8902 3A16 65F9 8900 3AD5 1600 A3EE 160A"            /* �.:.e��.:�..��.� */
	$"FFF7 F6F9 F5F5 00F5 F7F7 F8FD F909 2BF6"            /* ������.�������+� */
	$"F6F7 F8FB FEFF FD81 FEFC 17FB FCFA 5656"            /* ����������.���VV */
	$"F9F9 56F8 F9F9 FAFA FF16 16FF FEF8 81FC"            /* ��V������..����� */
	$"2BFD ACB5 16FC 89FD 1603 3A89 8965 FD16"            /* +���.���..:��e�. */
	$"0065 FE89 0565 3A3A 163A 65FD 89FA 16FB"            /* .e��.e::.:e���.� */
	$"89F8 16FB 8900 3AFA 1600 65FD 89F9 1601"            /* ��.��.:�..e���.. */
	$"3A65 FC89 003A FB16 0110 5FFD 8901 5F10"            /* :e��.:�..._��._. */
	$"FD02 0201 0133 FD89 0033 FB01 0033 F989"            /* �....3��.3�..3�� */
	$"045E 2C08 2C5E FC89 0033 F701 FD02 F910"            /* .^,.,^��.3�.�.�. */
	$"0816 3A89 895F 5F89 893A FD89 FC65 D416"            /* ..:��__��:���e�. */
	$"0096 EE16 17FF F7F5 FBF5 F6F5 F52B F9FC"            /* .��..��������+�� */
	$"FFFE FEAC F62B F6F8 FDFE FDFB 81FD F902"            /* �����+���������. */
	$"FEF9 F8FD 5602 F8F7 F8FE F900 FDFE 1607"            /* ����V.�����.��.. */
	$"FEFD 81F8 F856 FCFF B616 FC89 FD16 003A"            /* �����V���.���..: */
	$"FE89 0065 FE16 003A F589 0065 FA16 FB89"            /* ��.e�..:��.e�.�� */
	$"F816 FB89 FA16 003A FD89 0065 F816 0065"            /* �.���..:��.e�..e */
	$"FC89 003A FB16 0010 FC89 0110 10FD 0202"            /* ��.:�...��...�.. */
	$"0101 5EFE 8900 82FA 0100 33FB 8900 5EFB"            /* ..^��.��..3��.^� */
	$"01FC 8900 33F7 01FD 02F9 1002 163A 89FD"            /* .��.3�.�.�...:�� */
	$"1603 6589 8965 CD16 0090 EE16 04FF 2BF5"            /* ..e��e�..��..�+� */
	$"8100 FEF5 11FA FFFF ACFC FCFF 2BF6 F7FB"            /* �.��.�������+��� */
	$"81FD F9FA FA56 56FE F90D FAF9 F8F8 F7F8"            /* �����VV��.������ */
	$"56F7 F756 FBFA F9FF FE16 07FE ACF8 56F9"            /* V��V�����..���V� */
	$"F881 FFB7 16FC 89FC 1603 6589 8965 FD16"            /* ����.���..e��e�. */
	$"003A F789 0065 F916 FB89 F816 FB89 FA16"            /* .:��.e�.���.���. */
	$"0065 FD89 F716 0065 FC89 003A FB16 005F"            /* .e���..e��.:�.._ */
	$"FD89 003A FE10 FE02 0109 82FD 89F9 0100"            /* ��.:�.�..Ƃ���.. */
	$"33FC 8900 5EFA 01FC 89F7 01FD 02F8 1002"            /* 3��.^�.���.�.�.. */
	$"163A 65FC 1601 8965 CC16 0091 EE16 15FF"            /* .:e�..�e�..��..� */
	$"2BF5 F9F5 00F6 56FF FBFC FB56 2BFF 2BF6"            /* +���.�V����V+�+� */
	$"81AC F9FD FAFC F910 FAFA 81FA F9F7 F7F8"            /* �������.�������� */
	$"56F8 F7F8 FCFA F9AC 81FE 1607 FEFD F9F9"            /* V���������..���� */
	$"F8F7 ACFC B816 FC89 003A FC16 0165 65FA"            /* �����.��.:�..ee� */
	$"16F9 8900 65F8 16FB 89F8 16FB 89FA 16FC"            /* .��.e�.���.���.� */
	$"89F7 1600 65FC 8900 3AFB 16FC 89FD 1002"            /* ��..e��.:�.���.. */
	$"0202 58FD 8900 5EF8 0100 33FC 8900 5EFB"            /* ..X��.^�..3��.^� */
	$"0100 33FD 8900 57F7 01FD 02F9 1003 1616"            /* ..3��.W�.�.�.... */
	$"3A65 FD16 013A 89F9 1600 3AD4 1600 92EE"            /* :e�..:��..:�..�� */
	$"1616 ACF8 F6F7 56F5 F6F5 FE2B F8F7 F72B"            /* ..����V����+���+ */
	$"FD56 00FF 81AC FAFE 56FD F900 FAFE 8102"            /* �V.�����V��.���. */
	$"FAF8 F7FD 5605 F7F9 FAF9 81FE FD16 06FF"            /* ����V.�������..� */
	$"F9F9 FCF9 F7FF B816 FC89 0065 F316 003A"            /* �������.��.e�..: */
	$"FA89 F716 FB89 F816 FB89 FB16 003A FD89"            /* ���.���.���..:�� */
	$"0065 F716 0065 FC89 003A FC16 003A FC89"            /* .e�..e��.:�..:�� */
	$"FD10 0102 58FE 8900 5EF6 0100 33FC 8900"            /* �...X��.^�..3��. */
	$"5EFC 0100 08FD 8900 33F6 01FD 02F9 1003"            /* ^�...��.3�.�.�.. */
	$"1616 3A89 FD16 0189 5FFA 1602 3A89 3AD5"            /* ..:��..�_�..:�:� */
	$"1600 92EE 161A ACFA 0000 FD00 F500 FDFA"            /* ..��..��..�.�.�� */
	$"F8F7 F8F7 81FA F6FF 56FF 2BFF FAF8 FFFC"            /* ��������V�+����� */
	$"F9FE 8103 ACFD FAF8 FC56 05F9 FBF9 56FF"            /* ���.�����V.���V� */
	$"FCFE 1607 FF56 F9F9 FCFC FAFF B916 0065"            /* ��..�V�������..e */
	$"FC89 F216 FB89 0065 F716 FB89 F816 FB89"            /* ���.��.e�.���.�� */
	$"FB16 005F FD89 003A F716 0065 FC89 003A"            /* �.._��.:�..e��.: */
	$"FC16 0065 FD89 005F FD10 0058 FE89 002D"            /* �..e��._�..X��.- */
	$"F501 0033 FC89 005E FC01 035E 8957 08F5"            /* �..3��.^�..^�W.� */
	$"01FC 02F9 1002 1616 3AFD 8902 5F89 65F8"            /* .�.�....:��._�e� */
	$"8900 3AD5 1600 90EE 1609 FAFE F500 ACF5"            /* �.:�..��.����.�� */
	$"F500 FBFD FDF8 0BF9 FCFB FCF9 FFF9 81FD"            /* �.����.��������� */
	$"F8FC FBFC FA0D FFFB 56F9 FCFA 81FA F8AC"            /* �����.��V������� */
	$"F9F8 81FE FE16 07FE FAF8 F82B FEFE FFF7"            /* �����..����+���� */
	$"16FC 1CC8 1600 65FC 8900 65F3 16FB 8900"            /* .�.�..e��.e�.��. */
	$"65F7 16FB 89F8 16FB 89FB 1600 65FD 8900"            /* e�.���.���..e��. */
	$"3AF7 1600 65FC 8900 3AFC 16FC 8900 5FFE"            /* :�..e��.:�.��._� */
	$"1000 5FFE 8901 0202 F501 0033 FC89 005E"            /* .._��...�..3��.^ */
	$"FC01 0157 57F3 01FD 02F8 1002 1616 3AFE"            /* �..WW�.�.�....:� */
	$"89FE 65F7 89D4 1600 90ED 161B FF2B F5F8"            /* ��e���..��..�+�� */
	$"F72B 2BF8 FEF7 F8F8 F756 FFFE FB56 FFFB"            /* �++������V���V�� */
	$"2BFF F956 F9F9 FAF9 FEFA 0CF9 F9F8 ACF9"            /* +��V������.����� */
	$"81F9 F981 F956 F7FF FE16 05FC FDF9 2B2B"            /* �����V���..���++ */
	$"ACF9 16E2 1CDE 1600 3AFB 8900 3AF4 16FB"            /* ��.�.�..:��.:�.� */
	$"8900 65F7 16FB 89F8 16FB 89FB 1600 65FD"            /* �.e�.���.���..e� */
	$"8900 3AF7 1600 65FC 8900 3AFC 16FC 8900"            /* �.:�..e��.:�.��. */
	$"5FFE 10FE 89FD 02F6 0100 33FC 8900 5EFB"            /* _�.���.�..3��.^� */
	$"0100 08F4 01FC 02F9 10FE 1600 3AFE 8902"            /* ...�.�.�.�..:��. */
	$"5F65 65F7 8900 3AD5 1600 87ED 1616 FFF7"            /* _ee��.:�..��..�� */
	$"F52B FAF6 8100 FFF5 F856 F956 FEAC FC56"            /* �+���.���V�V���V */
	$"81FF F8FC FDFE 5600 F9FC 560C F956 ACFA"            /* ������V.��V.�V�� */
	$"FAF9 F9F8 FDF8 F9FA FDFE 1604 FEFF F9F8"            /* ����������..���� */
	$"FEFB 16DF 1CDE 16FA 89F4 16FB 8900 65F7"            /* ��.�.�.���.��.e� */
	$"16FB 89F8 16FB 89FB 1600 65FD 8900 65F7"            /* .���.���..e��.e� */
	$"1600 65FC 8900 3AFC 16FC 8902 6510 10FE"            /* ..e��.:�.��.e..� */
	$"8900 10FD 02F6 0100 33FC 8900 5EED 01FD"            /* �..�.�..3��.^�.� */
	$"02F8 10FE 1604 3A89 1616 89F6 1601 893A"            /* .�.�..:�..��..�: */
	$"D516 0080 EE16 18FA FFF5 F52B F9F5 FB00"            /* �..��..����+���. */
	$"FDF9 2B56 F856 81FF ACF9 FAFF FDFA FAAC"            /* ��+V�V���������� */
	$"FC56 FEF8 0C56 F9F9 FCFA FAF9 56FA 81F9"            /* �V��.V������V��� */
	$"56FE FD16 03FE FEFF ACFC 16DE 1CDE 16F9"            /* V��..�����.�.�.� */
	$"89F5 16FB 8900 65F7 16FB 89F8 16FB 89FB"            /* ��.��.e�.���.��� */
	$"1600 65FD 8900 65F7 1600 65FC 8900 3AFC"            /* ..e��.e�..e��.:� */
	$"16FB 8905 103A 8989 1010 FC02 F701 0033"            /* .��..:��..�.�..3 */
	$"FC89 005E EE01 FC02 F810 FE16 003A FE89"            /* ��.^�.�.�.�..:�� */
	$"005F C816 007F EE16 1D81 FEF5 F6F5 FBF6"            /* ._�...�..������� */
	$"8100 81FB 2BF8 56F9 56FB FF56 F9FF FFF9"            /* �.��+�V�V��V���� */
	$"FDFA 8156 56F9 F9FD AC0C FDFA FEF9 81FC"            /* ���VV����.������ */
	$"5656 ACF9 F981 FFFB 1CFD 16DB 1CDF 1600"            /* VV������.�.�.�.. */
	$"3AF9 8900 3AF7 16FB 8900 65F7 16FB 89F8"            /* :��.:�.��.e�.��� */
	$"16FB 89FB 1600 3AFC 89F7 1600 65FC 8900"            /* .���..:���..e��. */
	$"3AFC 16F8 8900 5FFE 10FC 0202 0101 08FB"            /* :�.��._�.�.....� */
	$"0100 33FC 8900 5EEF 01FC 02F8 10FC 1602"            /* ..3��.^�.�.�.�.. */
	$"6589 5FC7 1600 7EEE 1619 FB56 F5F6 F5FA"            /* e�_�..~�..�V���� */
	$"F7F8 F62B FFF6 56F8 FA56 F7AC ACF8 FDFF"            /* ���+��V��V������ */
	$"FCFE FAFB FE56 00F8 FEFA 0EF9 FBFD FF56"            /* �����V.���.����V */
	$"FAFF FAF8 FBF9 FAFA FBFF D11C DF16 F789"            /* �����������.�.�� */
	$"015F 3AFC 1601 3A65 FB89 0065 F716 FB89"            /* ._:�..:e��.e�.�� */
	$"F816 FB89 FB16 003A FC89 003A F816 0065"            /* �.���..:��.:�..e */
	$"FC89 003A FC16 0065 F989 FD10 FC02 0301"            /* ��.:�..e���.�... */
	$"5E89 08FC 0100 33FC 8900 5EEF 01FC 02F8"            /* ^�.�..3��.^�.�.� */
	$"16D3 1CED 1600 74EE 1601 AC2B FEF5 2B00"            /* .�.�..t�..�+��+. */
	$"FCF7 2BF5 F9FF F9F7 F9F8 F8F7 ACFB FCFA"            /* ��+������������� */
	$"FFF9 FDFB FBF8 FE56 F8F8 56F9 F956 FCFA"            /* �������V��V��V�� */
	$"F7FC 81F7 FBFC F9F9 FAAC FFD0 1CE1 1600"            /* ������������.�.. */
	$"3AE9 8900 65F7 16FB 89F8 16FB 89FA 16FB"            /* :�.e�.���.���.� */
	$"89F8 16FB 8900 3AFC 1600 3AFA 8900 65FC"            /* ��.��.:�..:��.e� */
	$"10FE 0204 3383 8989 5EFC 0100 33FC 8900"            /* .�..3���^�..3��. */
	$"5EF0 01FC 02F8 16CD 1CF2 1600 8500 1CEF"            /* ^�.�.�.�.�..�..� */
	$"1631 FEF6 F6F5 F500 F956 F7F5 F5F7 FFFA"            /* .1�����.�V������ */
	$"F8F7 56F7 F7FD 81FF FBFD FF81 FCFA FEFC"            /* ��V������������� */
	$"F8F8 F9FA 5656 FA81 F7F8 56F7 F9FE F9FD"            /* ����VV����V����� */
	$"FCF9 FFFD CB1C E616 0065 EA89 0065 F71C"            /* �����.�..e�.e�. */
	$"FB89 FC1C FD16 FB89 FA16 0065 FB89 025F"            /* ���.�.���..e��._ */
	$"1616 FE3A 0116 65FB 8900 3AFB 16F8 8900"            /* ..�:..e��.:�.��. */
	$"5FFE 3A01 5F83 FB89 FC01 0033 FC89 005E"            /* _�:._����..3��.^ */
	$"F101 FC02 F716 F91C 0065 FD89 0065 DB1C"            /* �.�.�.�..e��.e�. */
	$"F216 0074 FE1C F116 26FE F6F5 00F5 F6F5"            /* �..t�.�.&���.��� */
	$"ACF7 F5F5 F6FF FE56 F8F7 56F7 F8FD FFF9"            /* �������V��V����� */
	$"FEFF FCF9 81FB 81F9 F9FA F9FA F9F9 FBF7"            /* ���������������� */
	$"FEF8 082B FBFD FCFD 56F7 FFFD CA1C E716"            /* ��.+����V����.�. */
	$"0065 EA89 0040 F91C 0040 FB89 F91C 0016"            /* .e�.@�..@���... */
	$"FB89 003A FA16 EC89 003A FC16 0065 ED89"            /* ��.:�.�.:�..e� */
	$"FC01 005E FB89 F301 FB02 F716 F91C 0065"            /* �..^���.�.�.�..e */
	$"FB89 0065 DB1C F316 007B FC1C F316 02FD"            /* ��.e�.�..{�.�..� */
	$"F5F6 FE00 05F5 8156 00F6 F6FE FE23 F8F7"            /* ���..��V.����#�� */
	$"56F8 2BFB FFAC F9FF FFF9 81F9 56F8 F9F9"            /* V�+���������V��� */
	$"FBFC F9F9 FCF7 F8F8 562B 8181 FA81 5656"            /* ��������V+����VV */
	$"FAFF C81C EE16 FB1C 0065 EA89 0065 FA1C"            /* ���.�.�..e�.e�. */
	$"F989 FA1C 0065 FA89 0065 FB16 005F EC89"            /* ���..e��.e�.._� */
	$"0065 FC16 EE89 015E 02FE 0100 33FA 8900"            /* .e�.�.^.�..3��. */
	$"5EF5 01FB 02F6 16FA 1C04 4089 8965 65FD"            /* ^�.�.�.�..@��ee� */
	$"89D9 1CF5 1600 76EF 1C28 FCAC F6F6 F500"            /* ��.�..v�.(�����. */
	$"F500 F8FD 00F5 81FC F8FF FCF7 F8F9 F7FA"            /* �.��.����������� */
	$"FFFC F8F9 56FE F7FD F856 56FC FFFD F956"            /* ����V����VV����V */
	$"FCF8 F8FE F907 56AC 81F7 F7F8 F7FE AE1C"            /* �����.V��������. */
	$"0065 EA89 FC1C 0040 F789 0040 FE1C 0040"            /* .e��..@��.@�..@ */
	$"F789 0065 FB1C 0065 EC89 FB1C EF89 002D"            /* ��.e�..e��.�.- */
	$"FE02 005E F789 F801 FA02 F616 F91C 0289"            /* �..^���.�.�.�..� */
	$"8940 FE1C FE89 0040 D01C 0116 1600 76EF"            /* �@�.��.@�.....v� */
	$"1C34 FEFB 0000 F5F5 00F6 00FE 2B56 FEFB"            /* .4��..��.�.�+V�� */
	$"F9F9 FFFC 56F7 F9FC FBAC F9F8 2BF7 FA56"            /* ����V�������+��V */
	$"F9F9 F881 FDAC F9F9 ACF8 F9FA F9F9 F7FB"            /* ���������������� */
	$"ACF7 F7F8 F7F8 FFAD 1C00 65ED 8900 40FC"            /* ��������..e�.@� */
	$"1CF5 89FE 1C00 65F6 89FA 1C00 40EE 8900"            /* .���..e���..@�. */
	$"65FA 1C00 65F2 8900 33FE 0200 33F6 8900"            /* e�..e�.3�..3��. */
	$"5EFB 01F9 02F6 16F8 1C01 8940 FD1C 0340"            /* ^�.�.�.�..�@�..@ */
	$"8989 40CE 1C00 86EF 1C05 FFFA 00F5 F5F6"            /* ��@�..��..��.��� */
	$"FEF5 2C81 56F9 FFFA FAF9 FFFF ACF9 ACFC"            /* ��,�V����������� */
	$"FBF8 FEFE AC2B 2BF8 56FC F7F9 81FA 56FC"            /* �����++�V�����V� */
	$"FE56 81F9 56F9 F8FA F9AC 2BF7 F72B ACAC"            /* �V��V�����+��+�� */
	$"AB1C FC40 F91C FD40 F91C 0140 40FB 1C01"            /* �.�@�.�@�..@@�.. */
	$"4040 FC1C FE40 FD1C FD40 F81C FD40 F81C"            /* @@�.�@�.�@�.�@�. */
	$"FD40 F61C FE40 FB16 FD3A 0016 FC02 0A33"            /* �@�.�@�.�:..�.�3 */
	$"332D 0902 0101 082C 3333 FD01 F702 F616"            /* 3-�....,33�.�.�. */
	$"F81C 0140 89FB 1C02 8989 40CE 1C00 52EF"            /* �..@��..��@�..R� */
	$"1C05 AC81 F6F5 F5F6 FEF5 03F6 81FA FDFE"            /* ..��������.����� */
	$"F905 FF56 FDFF FEFD FE56 1CF7 FBFE F856"            /* �.�V�����V.����V */
	$"F8F9 81F7 56F9 56FF FEF9 F9FA FCFC FAF9"            /* ����V�V��������� */
	$"FAFC 56F8 FA81 56FF 811C CF1C F516 E702"            /* ��V���V��.�.�.�. */
	$"F516 F71C 0140 89FD 1C00 40FE 8900 40CE"            /* �.�..@��..@��.@� */
	$"1C00 54EE 1C06 FDF6 F5F5 F6F5 00FE F52A"            /* ..T�..������.��* */
	$"81FC F956 81FE F9F9 FEFF ACF8 F956 F7F8"            /* ���V���������V�� */
	$"FCFC FF56 F7AC F9F7 5656 FAFE ACFA FAAC"            /* ���V����VV������ */
	$"FCF9 F9FD F8FC F8FE FFF8 AC81 1CCF 1CF3"            /* ������������.�.� */
	$"16EB 02F3 16F7 1C01 4089 FD1C 0065 FE89"            /* .�.�.�..@��..e�� */
	$"FB1C 0189 40D5 1C00 53EF 1C04 FFFD F700"            /* �..�@�..S�..���. */
	$"00FE F5FE 002B FBFA 56F8 FCFE 56F9 F9FB"            /* .���.+��V���V��� */
	$"FEFC 56F8 F8FE ACFF FAF8 5656 FCF7 F7F8"            /* ��V�������VV���� */
	$"5656 81FF FBFA FAF9 2BFC ACAC F8FC FAF9"            /* VV������+������� */
	$"F9FF 811C CF1C F216 EF02 F216 F61C 0040"            /* ���.�.�.�.�.�..@ */
	$"FC89 FE65 0040 FA89 0040 D51C 004D EF1C"            /* ���e.@��.@�..M�. */
	$"0681 FF56 F500 F5F5 FE00 19F6 FEF9 F82B"            /* .��V�.���..����+ */
	$"FEAC F8F9 FBF9 81FF FAF9 F7FD F9F8 56F9"            /* ��������������V� */
	$"FAF8 81F8 2BFE F810 F9F9 FDAC F9F9 F8FC"            /* ����+��.�������� */
	$"56FC ACF8 F9F9 F8FE 8181 1CCE 1CF0 16F7"            /* V���������.�.�.� */
	$"02F0 16F4 1C00 40F1 89D4 1C00 46EE 1C03"            /* .�.�..@��..F�.. */
	$"FFF7 F500 FCF5 1A2B FFF8 F8F6 FFFD 56F9"            /* ���.��.+������V� */
	$"FEF9 F9FE FEFA FC81 FF56 F9F9 FCFB F9FB"            /* ���������V������ */
	$"F7F7 FEF8 0FF9 56F9 F956 F756 FCFA FFFA"            /* ����.�V��V�V���� */
	$"F9FA F900 FE81 1CCD 1CD7 16F3 1C00 40F1"            /* ���.��.�.�.�..@� */
	$"89D4 1C00 4EEE 1C36 FFF7 00F6 F5F6 F5F5"            /* ��..N�.6��.����� */
	$"F6F7 FEF8 F72B FEAC FBF7 ACF9 5656 FFFE"            /* �����+������VV�� */
	$"FCF9 FFAC FAFA 81FA F8FD F7F7 F956 56FA"            /* �������������VV� */
	$"56F8 F856 562B FEF8 FDAC 5656 AC81 FF81"            /* V��VV+����VV���� */
	$"1CCC 1CD9 16F2 1C02 4089 65F5 1C02 6589"            /* .�.�.�..@�e�..e� */
	$"40D5 1C00 4AEE 1C36 FF2B 002B F6F6 2B00"            /* @�..J�.6�+.+��+. */
	$"F681 FCF8 56F7 ACFE AC56 F856 56F8 F8AC"            /* ����V����V�VV��� */
	$"FFFD FBFF 81FB FA56 FAF9 FCF8 F956 FBAC"            /* �������V�����V�� */
	$"FD2B F7F7 F8F7 FAFB 56FF FAF8 81FF FE81"            /* �+������V������� */
	$"1CCB 1CDB 16F0 1C00 89F3 1C00 40D4 1C00"            /* .�.�.�..��..@�.. */
	$"44EE 1C14 FEFC 00F5 F62B 002B 00FD FBF8"            /* D�..��.��+.+.��� */
	$"F756 FCFE FDF8 F9F8 F7FE F806 ACAC FCFF"            /* �V���������.���� */
	$"81F9 F9FE 5606 ACF9 FAFB 81FF 81FC F708"            /* ����V.���������. */
	$"2BAC F9AC FCF9 ACFF FF81 1CC9 1CDF 16EE"            /* +���������.�.�.� */
	$"1C00 40C5 1C00 41EE 1C03 FBFA 00F5 FEF6"            /* ..@�..A�..��.��� */
	$"0E00 00FF FAF9 F881 FCFD FDF9 F9F7 F8F6"            /* ...������������� */
	$"FEF8 0AFC FCAC F956 56F8 F8FA 81FC FEF9"            /* �������VV������� */
	$"0C56 F8F7 F8F7 F956 56AC AC56 FBFB FEFF"            /* .V�����VV��V���� */
	$"811C C71C E316 AF1C 003E EE1C 0381 2BF5"            /* �.�.�.�..>�..�+� */
	$"F5FE F615 F500 FFF9 F956 FBFB FDAC FA56"            /* ���.�.���V�����V */
	$"56F8 2BF7 F7F8 F7F7 56F7 FDF8 0456 FAFD"            /* V�+�����V���.V�� */
	$"FAFA FEF9 0856 F7F8 56F8 F8AC FF56 FCFF"            /* ����.V��V����V�� */
	$"811C C51C E716 AD1C 0041 EE1C 04FA F6F5"            /* �.�.�.�..A�..��� */
	$"00F6 FDF5 0FFF 56F8 F8FC FBFD FBFC FCF8"            /* .���.�V��������� */
	$"F8F7 F8F8 56FE F80B F7F8 F8F7 F856 56FD"            /* ����V��.�����VV� */
	$"FFFD FD81 FEF8 04F9 F956 F9AC FEFF 03FB"            /* ������.��V����.� */
	$"FCFB FF81 1CC2 1CED 16AA 1C00 41F0 5F03"            /* ����.�.�.�..A�_. */
	$"1C1C FCF6 FDF5 1400 F5F6 FF56 F856 81FF"            /* ..����..���V�V�� */
	$"FFFC FBAC 81F8 F881 F8F8 56F8 FCF7 16F8"            /* ����������V���.� */
	$"F856 ACFC F9F9 FDF9 F7F9 ACAC F9FB ACFB"            /* �V�������������� */
	$"FFAC FBFB 81FF FD1C 815F 815F DB5F 0046"            /* �������.�_�_�_.F */
	$"F15F 1D1C 1C81 FCF6 00F5 F6F5 F500 F8FF"            /* �_...���.����.�� */
	$"FA56 F9FC FFFF FC81 FDF9 56FD ACF9 F856"            /* �V��������V����V */
	$"F8FE F717 F856 F8F8 F9FE F9F8 56FD F7F7"            /* ���.�V������V��� */
	$"FBFE FBF9 FBFF 81FE FDFB FBF8 FEFF FE1C"            /* ���������������. */
	$"815F 815F DC5F 0047 F15F 031C 1CFF FBFD"            /* �_�_�_.G�_...��� */
	$"F636 0000 F500 FEFE FFFF FAFE FCFC 81F8"            /* �6..�.���������� */
	$"56F9 56FE F956 56F8 F7F8 F8FB FE56 F8AC"            /* V�V��VV������V�� */
	$"FDF8 F881 F92B F8F8 81F9 FAAC FDFD FCFD"            /* �����+���������� */
	$"FFFE FFAC FEFB FE1C 1C81 5F81 5FDC 5F00"            /* �������..�_�_�_. */
	$"43EE 1C00 FDFE F50F F600 F5F6 F5F7 FFFE"            /* C�..���.�.������ */
	$"FAFF FEF8 FC81 5656 FEF9 22F8 56F8 F781"            /* ������VV��"�V��� */
	$"F956 FC81 F981 FFFF 56F8 FEF7 F7F8 F8F7"            /* �V������V������� */
	$"56AC FEFE F9FC FCFD ACFE FC81 ACFE 811C"            /* V��������������. */
	$"811C DA1C 0043 EE1C 1D81 FF2B 00F6 00F5"            /* �.�..C�..��+.�.� */
	$"00F5 2BFF FCF8 FBFE F7FC F956 F856 F956"            /* .�+��������V�V�V */
	$"F8F8 2BF9 FD56 56FE F918 81FD FEF8 FCF9"            /* ��+��VV��.������ */
	$"F7F7 56F7 F8FB FAF8 FDFC FFF9 81AC FB81"            /* ��V������������� */
	$"FAF8 AC81 1C81 1CDA 1C00 42ED 1C02 FEAC"            /* ����.�.�..B�..�� */
	$"FAFE 002A F500 2BFF F9F9 F8FA F8FE 5656"            /* ��.*�.+�������VV */
	$"F9F9 56F8 F7F7 FAFE F956 56F9 FAFA F9FD"            /* ��V������VV����� */
	$"FCF8 FE56 F856 56F8 FAFC 2BF8 81AC FDFE"            /* ���V�VV���+����� */
	$"F904 FAF9 F9F8 FC81 1C81 1CDA 1C00 44EE"            /* �.������.�.�..D� */
	$"1C0A FCFF F82B F6F5 F500 F6FC ACFE F90F"            /* .����+���.�����. */
	$"F8F7 FEFA F9FA F9F8 F8F7 56FF FBF7 5656"            /* ����������V���VV */
	$"FEF9 1956 FF56 FE56 F8F9 56F8 56FD F8F7"            /* ��.V�V�V��V�V��� */
	$"F82B FEFD FA56 F9F9 5656 F7FC F981 1C81"            /* �+���V��VV����.� */
	$"1CDB 1C00 44EE 1C10 FE2B F5F5 F6F5 2BF5"            /* .�..D�..�+����+� */
	$"00FF F9F8 81FC F756 ACFE FA26 81F7 56F7"            /* .������V���&��V� */
	$"FCFD F7F8 AC56 F9F9 56FD FEFD F9F8 F9F9"            /* �����V��V������� */
	$"5656 FC81 F92B F82B F7FA F9F8 F9F9 56F8"            /* VV���+�+������V� */
	$"5681 FE81 1C81 1CDB 1C00 44EE 1C04 FFFE"            /* V���.�.�..D�..�� */
	$"F9F6 00FE F532 2BFF FDAC FAFF FC56 F9FD"            /* ��.��2+������V�� */
	$"ACFB FF56 F8FC FE56 F8F8 F9F8 F956 F8FF"            /* ���V���V�����V�� */
	$"FEF9 F8F9 F9FA F8AC 81FE FCF7 F8F8 F7F8"            /* ���������������� */
	$"5656 F9F8 F8F9 F8F9 FF81 1C81 1CDB 1C00"            /* VV��������.�.�.. */
	$"3FED 1C17 FBFF F7F5 F5F6 F5F8 FDF9 F6F7"            /* ?�..������������ */
	$"FEFE 56FE FD81 FAFB F981 FFFA FE56 00F9"            /* ��V����������V.� */
	$"FE56 0EF7 FDF8 F7FA FFFA F7FB FCFA ACF9"            /* �V.������������� */
	$"5656 FAF9 04FA FFF9 F8FF 811C 811C DB1C"            /* VV��.������.�.�. */
	$"0042 ED1C 07FE F9F5 F500 002B 2BFE 000C"            /* .B�..����..++�.. */
	$"FEAC F981 FFFA FAF9 56FB FF81 FAFD F91D"            /* ��������V������. */
	$"56F8 F8F7 F8F7 F7FB FFF8 F9FD 5656 F8F8"            /* V�����������VV�� */
	$"5656 FAFA F956 FAF9 F8FD FFFC F8FF 811C"            /* VV���V���������. */
	$"811C DB1C 0045 EEFF 11AC FD81 F800 00F6"            /* �.�..E��.����..� */
	$"FAFD F500 FEFC F656 ACFE 56FE F926 FFAC"            /* ���.���V��V��&�� */
	$"F8F9 F9FA FAF9 56F7 2BF7 56F8 F8F9 F9F7"            /* ������V�+�V����� */
	$"FCF9 F8F8 56F8 F856 F9F9 FA56 5681 56F8"            /* ����V��V���VV�V� */
	$"FC56 F8FE 8181 FF81 FFDC FF01 6E28 E0FE"            /* �V���������.n(�� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"F9AC F8F8 81FA FCFF FDFF 00F5 F6FD 81FD"            /* ����������.����� */
	$"FBFB F7F8 FAAC FCFE F907 FA81 FAFA F9F9"            /* ���������.������ */
	$"F8F8 FD56 03F7 FCF9 F8FD F731 F8AC 8156"            /* ���V.������1���V */
	$"F9F9 F8FA FCF9 F9FA F9AC FCFE E0FE E0FE"            /* ���������������� */
	$"E0FE 1616 E0FE E0FE E0FE E0FE E0FE E0FE"            /* ��..������������ */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE FE16"            /* ���������������. */
	$"7FFE E016 16FE E0FE E0FE E0FE E0FE E0FE"            /* .��..����������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E016 16FE E0FE E0FE E016"            /* �������..������. */
	$"16FE E0FE E0FE E0FE E0FE E0FE E016 16FE"            /* .������������..� */
	$"E016 16FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* �..������������� */
	$"E0FE E0FE E0FE E016 16FE E0FE E0FE E0FE"            /* �������..������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE 1616 E0FE"            /* ������������..�� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E00E FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* �.�������������� */
	$"FEFE 1637 FEE0 FEE0 FE16 16E0 FE16 16E0"            /* ��.7�����..��..� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FB16 05FE"            /* �������������..� */
	$"E0FE E0FE E0FD 1609 FEE0 FEE0 FEE0 FEE0"            /* ������.��������� */
	$"FEE0 FC16 00E0 FE16 11E0 FE16 16E0 FEE0"            /* ���..��..��..��� */
	$"FEE0 FEE0 FE16 16E0 FEE0 FE01 7630 FEE0"            /* �����..����.v0�� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 56FF"            /* ��������������V� */
	$"FFAC FBF7 F9FF AC56 FAFF 00F5 00F6 ACF8"            /* �������V��.�.��� */
	$"FC56 F756 FDF9 FEF8 FAF9 FA81 FEAC F9FE"            /* �V�V������������ */
	$"5603 F956 56F9 FDF7 0EF6 2BF7 F82B FFFC"            /* V.�VV���.�+��+�� */
	$"56F9 F9F8 F7FF FBF9 FEFA 7FFF E0FE E0FE"            /* V���������.����� */
	$"E0FE E016 16FE E0FE E0FE E0FE E0FE E0FE"            /* ���..����������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"1616 E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ..�������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE 1616 E0FE E0FE E0FE"            /* ��������..������ */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE 1616"            /* ��������������.. */
	$"E0FE 1616 E0FE E0FE E0FE E0FE E0FE E0FE"            /* ��..������������ */
	$"E0FE E0FE E0FE E0FE 1616 E07F FEE0 FEE0"            /* ��������..�.���� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 1616"            /* ��������������.. */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FE16 16E0 FEE0 FEE0 FEE0 1616 FEE0 1616"            /* �..�������..��.. */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FE16"            /* ���������������. */
	$"16E0 FEE0 FEE0 FEE0 1616 FEE0 2516 16FE"            /* .�������..��%..� */
	$"E0FE E0FE E0FE E0FE 1616 E0FE E0FE E016"            /* ��������..�����. */
	$"16FE E0FE E0FE E0FE E0FE E0FE E016 16FE"            /* .������������..� */
	$"E0FE E001 5B29 E0FE E0FE E0FE E0FE E0FE"            /* ���.[)���������� */
	$"E0FE E0FE E0FA FFF9 FCFD F956 F8AC FDFC"            /* �����������V���� */
	$"FAFF 56FF 56F9 56F9 FEF8 F8F7 FC56 FCFA"            /* ��V�V�V������V�� */
	$"FEF9 07FB FCFC F956 F856 FAFD F904 56F8"            /* ��.����V�V���.V� */
	$"F72B 2BFC F80B 56F8 1616 F7FB FC81 1616"            /* �++��.V�..����.. */
	$"F9FF FE16 03E0 FEE0 FEFD 1602 E0FE E0FE"            /* ���..�����..���� */
	$"1609 E0FE 1616 E0FE 1616 E0FE FE16 08FE"            /* .���..��..���..� */
	$"E0FE E0FE E016 16FE FE16 00FE FD16 02E0"            /* �����..��..��..� */
	$"FEE0 FD16 01FE E0FE 1601 E0FE FC16 01FE"            /* ���..���..���..� */
	$"E0FE 1602 E0FE E0FD 1604 FEE0 FEE0 FEFE"            /* ��..����..������ */
	$"1600 FEFD 1605 E0FE E0FE E0FE FD16 00E0"            /* ..��..�������..� */
	$"FD16 02FE E0FE FE16 06FE E0FE E0FE E0FE"            /* �..����..������� */
	$"FE16 01FE E0FD 1602 FEE0 FEFE 1601 FEE0"            /* �..���..����..�� */
	$"FA16 01E0 FEFD 1602 E0FE E0FE 1601 E0FE"            /* �..���..����..�� */
	$"FC16 01FE E0FD 1605 FEE0 FEE0 FEE0 FE16"            /* �..���..�������. */
	$"01E0 FEFD 1604 E0FE E0FE E0FD 1600 FEFD"            /* .���..������..�� */
	$"1602 E0FE E0FE 1606 E0FE E0FE E0FE E0FD"            /* ..����..�������� */
	$"1601 FEE0 FE16 02E0 FEE0 FE16 32E0 FEE0"            /* ..���..����.2��� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 1616"            /* ��������������.. */
	$"FEE0 FEE0 FEE0 FE16 16E0 FEE0 FEE0 FEE0"            /* �������..������� */
	$"FEE0 FEE0 FEE0 1616 FEE0 FEE0 FE16 16E0"            /* ������..�����..� */
	$"FE16 01E0 FEFE 1601 FEE0 FD16 02FE E0FE"            /* �..���..���..��� */
	$"016B 2AFE E0FE E0FE E0FE E0FE E0FE E0FE"            /* .k*������������� */
	$"E0FC FFF7 2B2B ACF7 56F9 FFFC FDAC FF56"            /* ����++��V������V */
	$"81FF FFFD FC81 F856 F8F9 8181 5656 FDF9"            /* �������V����VV�� */
	$"FD56 07F9 F9FA F9FA F956 F8FD F706 F856"            /* �V.������V���.�V */
	$"F7F8 56F7 F8FB 1616 FAFA 1616 FE16 16E0"            /* ��V���..��..�..� */
	$"FEE0 1616 FE16 16E0 FEE0 FE16 16E0 FEFD"            /* ��..�..����..��� */
	$"1624 E0FE 1616 E016 16FE E0FE E0FE 1616"            /* .$��..�..�����.. */
	$"E0FE 1616 E016 16FE 1616 E016 16FE 1616"            /* ��..�..�..�..�.. */
	$"E016 16FE 1616 E0FE 165C E0FE E016 16FE"            /* �..�..��.\���..� */
	$"1616 E016 16FE 1616 E0FE E0FE E0FE 1616"            /* ..�..�..������.. */
	$"E016 16FE 1616 E0FE E0FE E0FE 1616 E0FE"            /* �..�..������..�� */
	$"1616 E016 16FE 1616 E016 16FE E0FE E0FE"            /* ..�..�..�..����� */
	$"1616 E016 16FE 1616 E016 16FE E0FE E016"            /* ..�..�..�..����. */
	$"16FE 1616 E016 16FE 1616 E016 16FE 1616"            /* .�..�..�..�..�.. */
	$"E016 16FE 1616 E0FE 165B E0FE E016 16FE"            /* �..�..��.[���..� */
	$"E0FE E0FE E0FE E016 16FE 1616 E0FE 1616"            /* �������..�..��.. */
	$"E0FE E0FE E0FE E016 16FE E016 16FE 1616"            /* �������..��..�.. */
	$"E016 16FE 1616 E0FE E0FE E016 16FE E0FE"            /* �..�..�����..��� */
	$"E016 16FE 1616 E0FE E0FE 1616 E0FE E0FE"            /* �..�..����..���� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE 1616 E0FE"            /* ������������..�� */
	$"E0FE E0FE E0FE FD16 09E0 FEE0 FEE0 FEE0"            /* �������.�������� */
	$"FEE0 FEFD 1616 E0FE E016 16FE E016 16FE"            /* ����..���..��..� */
	$"1616 E016 16FE E016 16FE E0FE E001 5A32"            /* ..�..��..����.Z2 */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FC FFFA"            /* ���������������� */
	$"F7F7 F8FB F7F8 F7FF FDFA ACFF FEFE ACFD"            /* ���������������� */
	$"FBFA F9F8 F956 F856 F9F9 56F9 F956 56F7"            /* �����V�V��V��VV� */
	$"F7F8 56FC F904 56F8 56F8 F8FC 5603 F8F8"            /* ��V��.V�V���V.�� */
	$"F7F8 FB16 01F7 F9FC 1609 FEE0 FE16 16E0"            /* ���..���.����..� */
	$"1616 FEE0 FD16 01FE E0FD 1601 FEE0 FC16"            /* ..���..���..���. */
	$"17E0 FEE0 FEE0 1616 FEE0 1616 FE16 16E0"            /* .�����..��..�..� */
	$"1616 FE16 16E0 1616 FEFC 1606 FE16 16E0"            /* ..�..�..��..�..� */
	$"FEE0 FEFC 1623 FE16 16E0 1616 FEE0 FEE0"            /* ����.#�..�..���� */
	$"FEE0 1616 FE16 16E0 1616 FEE0 FEE0 FEE0"            /* ��..�..�..������ */
	$"1616 FEE0 1616 FE16 16E0 FC16 11E0 FEE0"            /* ..��..�..��..��� */
	$"FEE0 1616 FEE0 FEE0 1616 FE16 16E0 FEFD"            /* ��..����..�..��� */
	$"160F E016 16FE 1616 E016 16FE 1616 E016"            /* ..�..�..�..�..�. */
	$"16FE FC16 07FE 1616 E0FE E0FE E0FE 161F"            /* .��..�..������.. */
	$"E0FE E0FE E0FE 1616 E016 16FE E016 16FE"            /* ������..�..��..� */
	$"E0FE E0FE E0FE 1616 E0FE 1616 E016 16FE"            /* ������..��..�..� */
	$"FC16 05FE E0FE E0FE E0FE 1601 E0FE FC16"            /* �..�������..���. */
	$"01FE E0FD 1642 FEE0 FEE0 FEE0 FEE0 FEE0"            /* .���.B���������� */
	$"FEE0 FEE0 FEE0 1616 FEE0 FEE0 FEE0 FEE0"            /* ������..�������� */
	$"FEE0 FE16 16E0 FEE0 FEE0 FEE0 FEE0 1616"            /* ���..���������.. */
	$"FEE0 FEE0 FE16 16E0 FE16 16E0 1616 FE16"            /* �����..��..�..�. */
	$"16E0 FE16 16E0 FEE0 FE01 6F0E FEE0 FEE0"            /* .��..����.o.���� */
	$"FEE0 FEE0 FEE0 FE81 FCFF FCFD F810 F981"            /* �������������.�� */
	$"F7F8 ACFC FDFC F9F9 F8FA FD81 FAF9 F9FD"            /* ���������������� */
	$"56FC F903 56F8 F7F7 FDF8 FEF9 0856 56F8"            /* V��.V�������.VV� */
	$"F856 56F9 FB56 FEF8 02F7 F7F8 FD16 7FFC"            /* �VV��V��.����..� */
	$"81AC 1616 FCFF F9E0 FEE0 1616 FE16 16E0"            /* ��..������..�..� */
	$"1616 FE16 16E0 FEE0 1616 FEE0 FE16 16E0"            /* ..�..���..���..� */
	$"FEE0 FEE0 FEE0 FE16 16E0 FE16 16E0 1616"            /* �������..��..�.. */
	$"FE16 16E0 1616 FE16 16E0 1616 FEE0 FEE0"            /* �..�..�..�..���� */
	$"1616 FEE0 FEE0 1616 FEE0 FEE0 1616 FE16"            /* ..����..����..�. */
	$"16E0 FEE0 FEE0 FE16 16E0 1616 FE16 16E0"            /* .������..�..�..� */
	$"FEE0 FEE0 FE16 16E0 FE16 16E0 1616 FE16"            /* �����..��..�..�. */
	$"16E0 FEE0 FEE0 FEE0 FE16 16E0 1616 FE7F"            /* .��������..�..�. */
	$"1616 E016 16FE 1616 E016 16FE 1616 E016"            /* ..�..�..�..�..�. */
	$"16FE 1616 E016 16FE 1616 E016 16FE E0FE"            /* .�..�..�..�..��� */
	$"E016 16FE E0FE E0FE E0FE 1616 E0FE E0FE"            /* �..�������..���� */
	$"E016 16FE 1616 E0FE 1616 E0FE E0FE E0FE"            /* �..�..��..������ */
	$"E016 16FE E016 16FE 1616 E016 16FE E0FE"            /* �..��..�..�..��� */
	$"E0FE E0FE E0FE E0FE 1616 E016 16FE E0FE"            /* ��������..�..��� */
	$"E016 16FE 1616 E0FE E0FE E0FE E0FE E0FE"            /* �..�..���������� */
	$"E0FE E0FE E0FE 1616 E0FE E0FE E0FE E016"            /* ������..�������. */
	$"2816 FEE0 1616 FEE0 FEE0 FEE0 FEE0 FE16"            /* (.��..���������. */
	$"16E0 FEE0 FEE0 1616 FEE0 1616 FE16 16E0"            /* .�����..��..�..� */
	$"1616 FEE0 1616 FEE0 FEE0 0163 09E0 FEE0"            /* ..��..����.c���� */
	$"FEE0 FEE0 FEE0 F9FD FF10 F956 F856 F956"            /* ���������.�V�V�V */
	$"ACFA 56F8 56FA FCFC 81FA 56FA F902 FAF9"            /* ��V�V�����V��.�� */
	$"F9FE FA01 F956 FDF8 1456 F8FA F9FC 5656"            /* ���.�V��.V����VV */
	$"F7F8 F816 16FA 1616 F816 16F7 F7FC FD16"            /* ���..�..�..����. */
	$"0356 FB81 81FE 160A FFFE E0FE 1616 E016"            /* .V����.�����..�. */
	$"16FE E0FD 1608 FEE0 FE16 16E0 FEE0 FEFE"            /* .���..���..����� */
	$"1613 FEE0 FEE0 FEE0 1616 FEE0 1616 FE16"            /* ..������..��..�. */
	$"16E0 1616 FEE0 FD16 01FE E0FE 1608 E0FE"            /* .�..���..���..�� */
	$"1616 E0FE E0FE E0FE 1602 E0FE E0FD 161E"            /* ..������..����.. */
	$"FEE0 FEE0 FEE0 1616 FE16 16E0 1616 FEE0"            /* ������..�..�..�� */
	$"FEE0 FEE0 FE16 16E0 1616 FE16 16E0 FEFE"            /* �����..�..�..��� */
	$"1606 FEE0 FEE0 FEE0 FEFE 1608 FEE0 1616"            /* ..��������..��.. */
	$"FE16 16E0 FEFD 1609 E016 16FE 1616 E016"            /* �..���.��..�..�. */
	$"16FE FD16 02E0 FEE0 FE16 07E0 FE16 16E0"            /* .��..����..��..� */
	$"FEE0 FEFD 1606 E0FE E0FE E0FE E0FE 1616"            /* ����..��������.. */
	$"E0FE E016 16FE E0FE E0FE E0FE E016 16FE"            /* ���..��������..� */
	$"1616 E016 16FE E0FE 1605 E0FE E0FE E0FE"            /* ..�..���..������ */
	$"FD16 02E0 FEE0 FE16 02E0 FEE0 FD16 19FE"            /* �..����..����..� */
	$"1616 E016 16FE 1616 E0FE E0FE E0FE E016"            /* ..�..�..�������. */
	$"16FE E0FE E016 16FE E0FD 1609 FEE0 FE16"            /* .����..���.����. */
	$"16E0 FEE0 FEE0 FC16 09E0 FE16 16E0 FE16"            /* .������.���..��. */
	$"16E0 FEFE 1608 FEE0 FEE0 1616 FEE0 FE01"            /* .���..����..���. */
	$"773F FEE0 FEE0 FEE0 FEE0 F9FD FFAC 8156"            /* w?�������������V */
	$"56F9 FBFD FAF9 56FD 56F8 F82B F9FA F9FB"            /* V�����V�V��+���� */
	$"ACFA 56F9 56F9 56F9 F9FA F9FA FEAC F9F9"            /* ��V�V�V��������� */
	$"F82B 56F8 F8FC ACFC 56F8 2BF7 F7F8 F856"            /* �+V�����V�+����V */
	$"FBFC FE56 7FF8 F856 81FD FAF9 F956 F8F7"            /* ���V.��V�����V�� */
	$"F7F8 00FC FFFA F9E0 FEE0 FEE0 FEE0 FEE0"            /* ��.������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FE16 16E0 FEE0 FEE0 FEE0 FEE0"            /* �����..��������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FE7F E0FE E0FE E0FE E0FE E0FE"            /* �����.���������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE 30E0 FEE0 FEE0 FEE0 FEE0"            /* ������0��������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 0172 16E0 FEE0 FEE0"            /* ��������.r.����� */
	$"FEE0 F9FE FFFB FAF9 5656 F8FC FBF9 FAF9"            /* ��������VV������ */
	$"F9AC FDF7 1CAC FBFC ACFD ACF8 56F8 56F9"            /* ����.�������V�V� */
	$"F9FA F9F9 ACF9 56F9 56F8 F9F9 F8FA F9F7"            /* ������V�V������� */
	$"F8F9 FEF7 00F8 FC56 FEF8 0A56 56FB FCFA"            /* ����.��V���VV��� */
	$"FAF9 56F8 2BF7 FEF8 2EFC FF81 FEE0 FEE0"            /* ��V�+���.������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FE16 7FE0 FEE0 FEE0"            /* ���������..����� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FE6F E0FE E0FE"            /* �����������o���� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE 0176 11FE"            /* ������������.v.� */
	$"E0FE E0FE E0FB FFFE FCF8 F9F7 F8F7 F7F8"            /* ���������������� */
	$"56FD F920 F8F7 F9F9 56F8 5656 F9F8 8156"            /* V�� ����V�VV���V */
	$"F8F9 81FC FEF8 56F9 56F9 F8F8 56FA 56F9"            /* ������V�V���V�V� */
	$"56F9 5656 F7FE 567F F8F8 5656 F856 56F8"            /* V�VV��V.��VV�VV� */
	$"F756 56F9 FBFC ACFD FEFF FDFD FCFA F9AC"            /* �VV������������� */
	$"FBF9 FEFD FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 7FFE E0FE E0FE E0FE"            /* ��������.������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E0FE E0FE E0FE E0FE"            /* ���������������� */
	$"E0FE E0FE E0FE E0FE E039 FEE0 FEE0 FEE0"            /* ���������9������ */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0 FEE0"            /* ���������������� */
	$"FEE0 FEE0 00A0 0083 00FF"                           /* ����.�.�.� */
};