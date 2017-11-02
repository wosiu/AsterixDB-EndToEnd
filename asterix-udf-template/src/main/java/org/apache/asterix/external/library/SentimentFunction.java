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
import org.apache.asterix.external.library.java.JObjects;
import org.apache.asterix.external.library.java.JTypeTag;
import org.apache.asterix.om.types.BuiltinType;

public class SentimentFunction implements IExternalScalarFunction {

    private JObjects.JString jString;

    @Override
    public void deinitialize() {
        // nothing to do here
    }

    @Override
    public void evaluate(IFunctionHelper functionHelper) throws Exception {
        // Read input record
        JObjects.JRecord inputRecord = (JObjects.JRecord) functionHelper.getArgument(0);
        JObjects.JString id = (JObjects.JString) inputRecord.getValueByName("id");
        JObjects.JString text = (JObjects.JString) inputRecord.getValueByName("text");

        // Populate result record
        JObjects.JRecord result = (JObjects.JRecord) functionHelper.getResultObject();
        result.setField("id", id);
        result.setField("text", text);

        if (text.getValue().length() > 66) {
            jString.setValue("Amazing!");
        } else {
            jString.setValue("Boring!");
        }
        result.setField("Sentiment", jString);
        functionHelper.setResult(result);
    }

    @Override
    public void initialize(IFunctionHelper functionHelper) throws Exception{
        jString = (JObjects.JString) functionHelper.getObject(JTypeTag.STRING);
//        BuiltinType.
    }

}
