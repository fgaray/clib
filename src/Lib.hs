{-# LANGUAGE ForeignFunctionInterface #-}
module Lib where


import Foreign.C.Types
import Foreign.Ptr
import Data.IORef
import Control.Concurrent.STM.TVar
import System.IO.Unsafe

import Types

state :: IORef State
{-# NOINLINE state #-}
state = unsafePerformIO (newIORef newState)


foreign export ccall
    test :: IO ()

foreign export ccall
    add_function_setNumberOfSegments :: FunPtr (ArchHelper -> Int -> IO ()) -> IO ()

foreign export ccall
    add_function_newArchHelper :: FunPtr (IO ArchHelper) -> IO ()

foreign export ccall
    add_function_testFFI :: FunPtr (IO ()) -> IO ()

{-Dynamics imports-}
foreign import ccall "dynamic"
    mkTestFFI :: FunPtr (IO ()) -> IO ()

foreign import ccall "dynamic"
    mkSetNumberOfSegments :: FunPtr (ArchHelper -> Int -> IO ()) -> ArchHelper -> Int -> IO ()

foreign import ccall "dynamic"
    mkNewArchHelper :: FunPtr (IO ArchHelper) -> IO ArchHelper


test :: IO ()
test = do
    s <- readIORef state
    let testFFI' = testFFI $ functions s
    case testFFI' of
        Nothing -> error "testFFI not set"
        Just testFFIFn -> testFFIFn


add_function_setNumberOfSegments :: FunPtr (ArchHelper -> Int -> IO ()) -> IO ()
add_function_setNumberOfSegments fn = do
    s <- readIORef state
    let s' = State { 
        functions = (functions s) {
            setNumberOfSegments = Just (mkSetNumberOfSegments fn)
            } 
        }
    writeIORef state s'



add_function_newArchHelper :: FunPtr (IO ArchHelper) -> IO ()
add_function_newArchHelper fn = do
    s <- readIORef state
    let s' = State { 
        functions = (functions s) {
            newArchHelper = Just (mkNewArchHelper fn)
            } 
        }
    writeIORef state s'


add_function_testFFI :: FunPtr (IO ()) -> IO ()
add_function_testFFI fn = do
    s <- readIORef state
    let s' = State { functions = (functions s) { testFFI = Just (mkTestFFI fn)  } }
    writeIORef state s'
