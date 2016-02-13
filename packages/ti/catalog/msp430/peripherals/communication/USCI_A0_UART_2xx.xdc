/* 
 *  Copyright (c) 2008 Texas Instruments and others.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 * 
 *  Contributors:
 *      Texas Instruments - initial implementation
 * 
 * */
import ti.catalog.msp430.peripherals.clock.IClock;

/*!
 * Universal Serial Communication Interface A0 UART 2xx
 */
metaonly module USCI_A0_UART_2xx inherits IUSCI_A0_UART {
    /* Add 2xx-specific stuff here */
    
    /*
     *  ======== create ========
     */
    create(IClock.Instance clock);

instance:
    /*! @_nodoc */
    config IClock.Instance clock;

    /*! Determine if each Register needs to be forced set or not */
    readonly config ForceSetDefaultRegister_t forceSetDefaultRegister[] =
    [
        { register : "UCA0CTL0"   , regForceSet : false },
        { register : "UCA0CTL1"   , regForceSet : false },
        { register : "UCA0BR0"    , regForceSet : false },
        { register : "UCA0BR1"    , regForceSet : false },
        { register : "UCA0MCTL"   , regForceSet : false },
        { register : "UCA0STAT"   , regForceSet : false },
        { register : "UCA0RXBUF"  , regForceSet : false },
        { register : "UCA0TXBUF"  , regForceSet : false },
        { register : "UCA0ABCTL"  , regForceSet : false },
        { register : "UCA0IRTCTL" , regForceSet : false },
        { register : "UCA0IRRCTL" , regForceSet : false }
    ];
}
/*
 *  @(#) ti.catalog.msp430.peripherals.communication; 1, 0, 0,; 12-4-2015 21:40:13; /db/ztree/library/trees/platform/platform-q16/src/
 */
