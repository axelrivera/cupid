//
//  SimpleContactListener.h
//
//  Created by Axel Rivera on 7/1/12.
//  Copyright 2012 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

class SimpleContactListener : public b2ContactListener
{
public:
    id _layer;
    
    SimpleContactListener(id layer) : _layer(layer) { 
    }
    
    void BeginContact(b2Contact *contact) { 
        [_layer beginContact:contact];
    }
	
    void EndContact(b2Contact *contact) { 
        [_layer endContact:contact];
    }
	
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold) { 
    }
	
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {  
    }	
};
