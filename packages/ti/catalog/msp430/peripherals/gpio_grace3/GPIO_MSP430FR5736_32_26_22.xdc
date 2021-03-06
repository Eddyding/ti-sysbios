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
import ti.catalog.msp430.peripherals.clock.CS as CS;

/*!
 *  ======== GPIO for MSP430FR5736_32_26_22 ========
 *  MSP430 General Purpose Input Output Ports
 */
metaonly module GPIO_MSP430FR5736_32_26_22 inherits IGPIO {
    /*!
     *  ======== create ========
     *  Create an instance of this peripheral. Use a customized
     *  init function so that we can get access to the CS
     *  instances.
     */
    create(CS.Instance clock);

instance:
    /*! @_nodoc */
    config CS.Instance clock;
    
    config Int numPortInterrupts = 4;
}
/*
 *  @(#) ti.catalog.msp430.peripherals.gpio_grace3; 1, 0, 0,2; 1-29-2016 10:00:51; /db/ztree/library/trees/platform/platform-q17/src/
 */

