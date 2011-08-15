{-# LANGUAGE FlexibleInstances, KindSignatures, MultiParamTypeClasses, NoImplicitPrelude, RankNTypes #-}
{-# OPTIONS -Wall #-}

-- | tipycal optimization menu

module Language.Paraiso.Optimization (
  optimize,
  Level(..),
  Ready
  ) where

import qualified Algebra.Additive            as Additive
import           Data.Typeable
import           Language.Paraiso.Annotation
import           Language.Paraiso.OM
import           Language.Paraiso.Optimization.BoundaryAnalysis
import           Language.Paraiso.Optimization.DecideAllocation
import           Language.Paraiso.Optimization.DependencyAnalysis
import           Language.Paraiso.Optimization.Graph
import           Language.Paraiso.Optimization.Identity
import           Language.Paraiso.Prelude
import           Language.Paraiso.Tensor (Vector)


-- | (Ready v g) indicates that the pair (v, g) has all the instances 
--   to receive full optimization services.
class (Vector v, 
       Additive.C g, 
       Ord g, 
       Typeable g,
       Show (v g)) 
      => Ready (v :: * -> *) (g :: *)

optimize :: (Ready v g)            
            => Level 
            -> OM v g Annotation 
            -> OM v g Annotation
            
optimize level = case level of
  O0 -> gmap identity . writeGrouping . gmap boundaryAnalysis . gmap decideAllocation
  _  -> optimize O0

data Level 
  = O0 -- perform mandatory code analysis
  | O1
  | O2
  | O3