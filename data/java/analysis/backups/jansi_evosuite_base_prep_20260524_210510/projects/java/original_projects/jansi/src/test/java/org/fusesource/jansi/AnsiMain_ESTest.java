/*
 * Copyright (C) 2009-2023 the original author(s).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.fusesource.jansi;

import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import org.evosuite.runtime.EvoRunner;
import org.evosuite.runtime.EvoRunnerParameters;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.evosuite.runtime.EvoAssertions.*;
import static org.junit.Assert.*;

@RunWith(EvoRunner.class)
@EvoRunnerParameters(
        mockJVMNonDeterminism = true,
        useVFS = true,
        useVNET = true,
        resetStaticState = true,
        separateClassLoader = true)
public class AnsiMain_ESTest extends AnsiMain_ESTest_scaffolding {

    @Test(timeout = 4000)
    public void test0() throws Throwable {
        Future<?> future = executor.submit(new Runnable() {
            @Override
            public void run() {
                try {
                    String[] stringArray0 = new String[7];
                    // Undeclared exception!
                    try {
                        AnsiMain.main(stringArray0);
                        fail("Expecting exception: NoClassDefFoundError");

                    } catch (NoClassDefFoundError e) {
                        //
                        // Could not initialize class org.fusesource.jansi.internal.CLibrary$WinSize
                        //
                        verifyException("org.fusesource.jansi.AnsiMain", e);
                    }
                } catch (Throwable t) {
                    // Need to catch declared exceptions
                }
            }
        });
        future.get(4000, TimeUnit.MILLISECONDS);
    }

    @Test(timeout = 4000)
    public void test1() throws Throwable {
        AnsiMain ansiMain0 = new AnsiMain();
    }
}
