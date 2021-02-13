{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_doublePend (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/arnav/Documents/sandbox/.cabal-sandbox/bin"
libdir     = "/home/arnav/Documents/sandbox/.cabal-sandbox/lib/x86_64-linux-ghc-8.6.5/doublePend-0.1.0.0-41lAn9cvbOaJ5KVv3dNnHB-doublePend"
dynlibdir  = "/home/arnav/Documents/sandbox/.cabal-sandbox/lib/x86_64-linux-ghc-8.6.5"
datadir    = "/home/arnav/Documents/sandbox/.cabal-sandbox/share/x86_64-linux-ghc-8.6.5/doublePend-0.1.0.0"
libexecdir = "/home/arnav/Documents/sandbox/.cabal-sandbox/libexec/x86_64-linux-ghc-8.6.5/doublePend-0.1.0.0"
sysconfdir = "/home/arnav/Documents/sandbox/.cabal-sandbox/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "doublePend_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "doublePend_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "doublePend_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "doublePend_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "doublePend_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "doublePend_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
