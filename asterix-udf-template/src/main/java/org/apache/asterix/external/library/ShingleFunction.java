/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.asterix.external.library;

import org.apache.asterix.external.api.IExternalScalarFunction;
import org.apache.asterix.external.api.IFunctionHelper;
import org.apache.asterix.external.library.java.JObjects.JOrderedList;
import org.apache.asterix.external.library.java.JObjects.JInt;
import org.apache.asterix.external.library.java.JObjects.JString;
import org.apache.asterix.external.library.java.JTypeTag;

public class ShingleFunction implements IExternalScalarFunction {
    @Override
    public void deinitialize() {
        // nothing to do here
    }

    @Override
    public void evaluate(IFunctionHelper functionHelper) throws Exception {
        String text = ((JString) functionHelper.getArgument(0)).getValue();
        int n = ((JInt) functionHelper.getArgument(1)).getValue();

        JOrderedList jList = new JOrderedList(functionHelper.getObject(JTypeTag.STRING));

        for (int i = 0; i <= text.length() - n; i++) {
            JString shingl = (JString) functionHelper.getObject(JTypeTag.STRING);
            shingl.setValue(text.substring(i, i + n));
            jList.add(shingl);
        }

        functionHelper.setResult(jList);
    }

    @Override
    public void initialize(IFunctionHelper functionHelper) throws Exception{
        // nothing to do here
    }
}
