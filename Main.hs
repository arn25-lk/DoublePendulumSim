{- #LANGUAGE ScopedTypeVariables# -}

module Main(main) where

import Graphics.Gloss
import Graphics.Gloss.Data.ViewPort
import Graphics.Gloss.Geometry.Angle 
import Control.Monad (when)
import Data.IORef (IORef, newIORef,readIORef, writeIORef)

fps :: Int
fps = 60

g :: Double
g = 9.81

data Pendulum = Pend{
a1 :: Float,
a2 :: Float,
m1 :: Float,
m2 :: Float,
c1pos :: (Float, Float),
c2pos:: (Float, Float),
vel :: (Float, Float),
l1 :: Float,
l2 :: Float
} deriving (Eq, Show)

data Tracing = Y | N 

render :: Pendulum -> Picture
render pend = color white (pictures lst) where 
    lst = [uncurry translate (c1pos pend) $ circleSolid 40, line [(0,0),c1pos pend, c2pos pend], 
        uncurry translate (c2pos pend) $ circleSolid 40]

takeInput :: IO(Pendulum)
takeInput = do 
    putStrLn "Add mass of Bob 1"
    m1<- readLn :: IO Float
    putStrLn "Add mass of Bob 2"
    m2 <- readLn :: IO Float
    putStrLn "Add length of Primary Bob"
    l1 <- readLn :: IO Float
    putStrLn "Add length of Secondary Bob"
    l2 <- readLn :: IO Float
    putStrLn "Add initial angle 1"
    a1 <- readLn :: IO Float
    putStrLn "Add initial angle 2"
    a2 <- readLn :: IO Float
    return Pend { 
    m1 = m1, 
    m2 = m2,
    a1 = degToRad a1, 
    a2 = degToRad a2, 
    c1pos = (l1*100* sin(degToRad a1),(-l1 )* 100 * cos(degToRad a1)), 
    c2pos = (l1 * 100 * sin(degToRad a1) + l2 * 100 * sin(degToRad a2), (-l1 ) * 100 * cos (degToRad a1) - l2 * 100 * cos(degToRad a2)) , 
    vel =(0,0), 
    l1 = l1, 
    l2 = l2 }
initial :: Pendulum
initial = Pend { m1 = 3, m2 = 2, a1 = degToRad 10, a2 = degToRad 0, l1 = 4, l2 = 3, c1pos = ((4*100* sin(degToRad 10)), (-4* 100 * cos(degToRad 10))), vel = (0,0),
c2pos = ( (4*100* sin(degToRad 10) + 3* 100 * sin(degToRad 0)), (-4* 100 * cos(degToRad 10)-3* 100*cos(degToRad 0 )))} 

calcRest :: Float -> Pendulum -> Pendulum
calcRest dt pend = Pend {
    c1pos = (x1', y1'),
    c2pos = (x2',y2'),
    a1 = a1',
    a2 = a2',
    vel = (v1', v2'),
    m1 = m1,
    m2 = m2,
    l1 = l1,
    l2 = l2
    }
    where 
    (x1,y1) = c1pos pend
    a1 = a1
    a2 = a2
    l1 = l1
    l2 = l2
    m1 = m1
    m2 = m2
    v1 = fst (vel pend)
    v2 = snd (vel pend)
    --Updated values
    ax' = realToFrac (-g* ((2*m1)+m2)* sin(a1) - m2*g*sin(a1-2*a2) - realToFrac num2 )/den 
        where 
        num1 = v2*v2*l2 + v1*v1*l1*cos(a1-a2)
        num2 = 2*sin(a1-a2)*m2*num1 
        den = l1 *(2*m1+m2-m2(cos(2*a1-2*a2)))
    ay' = realToFrac (2 * sin(a1- a2) * num1)/den
        where
        num1 = a1*a1*l1*(m1+m2) + g*(m1+m2)* cos(a1) + a2*a2*l2*m2*cos(a1-a2)
        den = l2 *(2*m1+m2-m2(cos(2*a1-2*a2)))
    v1' = v1 + ax' * dt * 10
    v2' = v2 + ay' * dt * 10
    a1' = a1 + v1' * dt * 10
    a2' = a2 + v2' * dt * 10

    x1' = x1 + l1 * sin(a1') 
    y1' = y1 - l1 * cos(a1') 
    x2' = x1' + l2 * sin(a2')
    y2' = y1' - l2 * cos (a2')

-- Initialize the screen
window :: Display
window = InWindow "Simulation" (2000,2000) (200,200)

background :: Color
background = black

main :: IO ()
main = simulate window background fps initial render (const calcRest)

-- pictures = group of pictures
