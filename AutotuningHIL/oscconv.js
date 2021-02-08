// costanti per fso.OpenTextFile
var enuOpenTextFileModes = {
	ForReading: 1,
	ForWriting: 2,
	ForAppending: 8
}

var m_fso = new ActiveXObject("Scripting.FileSystemObject")

function splitString(s, sep, strescape)
{
	var curTok = ""
	var arr = []
	var inStr = false
	
	for (var i = 0; i < s.length; i++)
	{
		var c = s.charAt(i)
		
		if (inStr)
		{
			if (c == strescape)
			{
				inStr = false
				arr.push(curTok)
				curTok = ""
			}
			else
				curTok += c
		}
		else if (c == sep)
		{
			if (curTok != "")
			{
				arr.push(curTok)
				curTok = ""
			}
		}
		else if (c == strescape)
		{
			inStr = true
		}
		else
			curTok += c
	}
	
	if (curTok != "" || inStr)
		arr.push(curTok)
	
	return arr
}

function ReadCodeIDFromSymtab(sym)
{
	try
	{
		var f = m_fso.OpenTextFile( sym, enuOpenTextFileModes.ForReading )
	}
	catch(err)
	{
		WScript.Echo("ERROR: can not open file " + sym)
		WScript.Quit(2)
	}

	var line = f.ReadLine()
	if (line.substr(0,3) != "ID ")
	{
		WScript.Echo("ERROR: invalid symbol table: " + sym)
		WScript.Quit(2)
	}
	
	return parseInt(line.substr(3))
}

// sostituzione di argomenti in una stringa nel formato %1, %2 ecc
function FormatMsg()
{
	if (arguments.length == 0) return ""
	var msg = arguments[0]
	for (var i = 1; i < arguments.length; i++)
		msg = msg.replace("%" + i, arguments[i])
	return msg
}

function GetFileName(f)
{
	// la m_fso.GetBaseName nel caso di file con più estensioni toglie solo l'ultima, non dal primo punto in poi
	f = m_fso.GetFileName(f)
	var pos = f.indexOf(".")
	if (pos != -1)
		return f.substr(0,pos)
	else
		return pos
}

//      count	type	name	_um	descr	_scale	_ofs	_trg	bitpos	addr
//SIGN -4000	6		"FLAG"	""	""		1		0		1		0		"0x00764B12"

var m_OSCType2IEC = {
	1: "INT",
	2: "DINT",
	3: "WORD",
	4: "DWORD",
	5: "REAL",
	6: "BOOL",
	12: "SINT",
	13: "BYTE"
}

// indici degli argomenti riga di comando
var ARG_OSC = 0
var ARG_SYT = 1
var ARG_TGTID = 2
var ARG_OPT = 3

// indici dei campi del record SIGN
var ARR_RECTYPE = 0
var ARR_IDX = 1
var ARR_TYPE = 2
var ARR_NAME = 3
var ARR_UM = 4
var ARR_DESCR = 5
var ARR_SCALE = 6
var ARR_OFS = 7
var ARR_TRG = 8
var ARR_BITPOS = 9
var ARR_ADDR = 10

var ARR_NUM_FIELDS = 11

function main(args)
{
	// -------- parsing opzioni riga di comando
	if (args.length < 2)
	{
		WScript.Echo("Usage: cscript OSCconv.js filenameIn.osc filenameOut.syt.xml targetID [/append] [/codeID:oldsymtab.sym] [/name:appname]")
		return 1
	}
	
	var srcOSC = args(ARG_OSC)
	var dstSYT = args(ARG_SYT)
	var tgtID = args(ARG_TGTID)
	
	var optAppend = false
	var oldSymtab = ""
	var appName = ""
	
	for (var i = ARG_OPT; i < args.length; i++)
	{
		if (args(i) == "/append")
			optAppend = true
		else if (args(i).substr(0,8) == "/codeID:")
			oldSymtab = args(i).substr(8)
		else if (args(i).substr(0,6) == "/name:")
			appName = args(i).substr(6)
	}
	
	
	
	// ------------- apertura sorgente OSC
	try
	{
		var f = m_fso.OpenTextFile( srcOSC, enuOpenTextFileModes.ForReading )
	}
	catch(err)
	{
		WScript.Echo("ERROR: can not open file " + srcOSC)
		return 1
	}

	// ----------- creazione/apertura SYT destinazione
	var xmldoc = new ActiveXObject("Msxml2.DOMDocument.6.0")
	xmldoc.async = false
	
	var varsNode
	if (optAppend)
	{
		if (!xmldoc.load(dstSYT))
		{
			WScript.Echo("ERROR: can not open file " + dstSYT)
			return 1
		}
		
		varsNode = xmldoc.selectSingleNode("/LLSymbolTable/GlobalVars")
	}
	else
	{
		var codeID = 0
		if (oldSymtab != "")
			// import code ID da vecchia SYM di MdPlc5
			codeID = ReadCodeIDFromSymtab(oldSymtab)
		
		var rootNode = xmldoc.appendChild(xmldoc.createElement("LLSymbolTable"))
		
		if (appName == "")
			appName = GetFileName(dstSYT)
		
		rootNode.setAttribute("Name", appName)
		rootNode.setAttribute("CodeId", codeID)
		rootNode.setAttribute("TargetID", tgtID)
		rootNode.appendChild(xmldoc.createElement("CaseSensitive")).text = "true"
		
		varsNode = rootNode.appendChild(xmldoc.createElement("GlobalVars"))
	}
	
	
	// ----------- processing dei record del OSC
	var totOk = 0
	var totSkipped = 0
	
	while (!f.AtEndOfStream)
	{
		var line = f.ReadLine()
		var arr = splitString(line, ' ', '"')
		
		if (arr[ARR_RECTYPE] != "SIGN")
		{
			WScript.Echo(FormatMsg("WARNING: unknown record type: %1 (%2)", arr[ARR_RECTYPE], arr[ARR_NAME]))
			totSkipped++
			continue
		}
		
		if (arr.length != ARR_NUM_FIELDS)
		{
			WScript.Echo(FormatMsg("WARNING: invalid number of fields: %1 (%2)", arr.length, arr[ARR_NAME]))
			totSkipped++
			continue
		}
		
		var type = m_OSCType2IEC[arr[ARR_TYPE]]
		if (type === undefined)
		{
			WScript.Echo(FormatMsg("WARNING: unsupported signal type: %1 (%2)", arr[ARR_TYPE], arr[ARR_NAME]))
			totSkipped++
			continue
		}
		
		if (arr[ARR_BITPOS] != 0)
		{
			WScript.Echo(FormatMsg("WARNING: unsupported bitPos value: %1 (%2)", arr[ARR_BITPOS], arr[ARR_NAME]))
			totSkipped++
			continue
		}
	
		//il meccanismo con cui viene generato il file potrebbe portare alla presenza di alcuni doppioni nelle variabili "sys", che vengono scartati
		var node = xmldoc.selectNodes( "/LLSymbolTable/GlobalVars/Var[@Name='" + arr[ ARR_NAME ] + "']" )
		if( node.length >= 1 )
		{
			totSkipped++
			continue
		}
		
		var varNode = varsNode.appendChild(xmldoc.createElement("Var"))
		varNode.setAttribute("Name", arr[ARR_NAME])
		varNode.setAttribute("Type", type)
		varNode.setAttribute("Addr", arr[ARR_ADDR])
		varNode.setAttribute("Descr", arr[ARR_DESCR])  // TODO descr? attualmente non presente in sym.xml
	
		totOk++
	}
	
	// -------------------- salvataggio e fine (se errore solleva eccezione!)
	xmldoc.save(dstSYT)
	
	WScript.Echo(FormatMsg("\nConversion completed: %1 ok, %2 skipped", totOk, totSkipped))
	return 0
}

var retval = main(WScript.arguments)
WScript.Quit(retval)
