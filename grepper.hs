import System.Environment
import System.IO
import Text.Regex.PCRE ((=~), RegexMaker, RegexContext, match, makeRegexOpts, compCaseless, execBlank, compBlank)

(=~+) ::
	( RegexMaker regex compOpt execOpt source
	, RegexContext regex source1 target )
	=> source1 -> (source, compOpt, execOpt) -> target
source1 =~+ (source, compOpt, execOpt)
	= match (makeRegexOpts compOpt execOpt source) source1


main = do
	(fileName:args) <- getArgs
	contents <- readFile fileName
	let allLines = lines contents
	    matchedLines = filter (\x -> x =~+ ("Line", compBlank, execBlank) :: Bool)
	putStr $ unlines $ matchedLines allLines



--main = do
--	line <- getLine
--	if null line
--	then return ()
--	else if line =~ "line" :: Bool
--	then do
--			putStrLn $ "Matched:" ++ line
--			main
--	else do
--		putStrLn "No Match"
--		main

