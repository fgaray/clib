module Types where

import Foreign.C.Types
import Foreign.Ptr

data ArchHelperPtr
type ArchHelper = Ptr ArchHelperPtr


data State = State
    { functions :: Functions
    }


data Functions = Functions
    { setNumberOfSegments :: Maybe (ArchHelper -> Int -> IO ())
    , newArchHelper       :: Maybe (IO ArchHelper)
    , testFFI             :: Maybe (IO ())
    }

newState :: State
newState = State newFunctions

newFunctions :: Functions
newFunctions = Functions Nothing Nothing Nothing
